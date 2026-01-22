import { RoomViewModel } from '../viewmodel/RoomViewModel';
import { DeviceSwitch } from '../view/DeviceSwitch';
import { ControlPanel } from '../view/ControlPanel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct ServiceControl {
  @Local viewModel: RoomViewModel = new RoomViewModel();
  @Param roomNumber: string = '';

  async aboutToAppear() {
    await this.viewModel.init(getContext());
    if (this.roomNumber) {
      this.viewModel.setRoomNumber(this.roomNumber);
    }
    await this.viewModel.loadRoomState();
  }

  build() {
    Stack() {
      // 背景图片
      Image($r('app.media.service_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        

      Column() {
        // 顶部导航
        Row() {
          Image($r('app.media.light_icon_back'))
            .width(24)
            .height(24)
            .margin({ right: 20 })
            .onClick(() => {
              router.back();
            })

          Text('服务控制')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 20, right: 20 })
        .margin({ top: 20, bottom: 40 })

        // 请勿打扰卡片
        Column() {
          Text('请勿打扰')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .margin({ bottom: 16 })

          Row() {
            Image($r('app.media.service_icon_do_not_disturb'))
              .width(40)
              .height(40)
              .margin({ right: 16 })

            Column() {
              Text('请勿打扰')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .margin({ bottom: 4 })

              Text(this.viewModel.roomModel.service.doNotDisturb ? '已开启' : '已关闭')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .opacity(0.7)
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ right: 20 })

            DeviceSwitch({
              isOpened: this.viewModel.roomModel.service.doNotDisturb,
              onChange: (value: boolean) => {
                this.viewModel.toggleDoNotDisturb();
              }
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding(20)
        .borderRadius(16)
        .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
        .backgroundColor('rgba(0,0,0,0)')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [
            [0x000000, 0.7],
            [0x000000, 1.0]
          ]
        })
        .margin({ bottom: 30 })

        // 清理房间卡片
        Column() {
          Text('客房服务')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .margin({ bottom: 16 })

          Row() {
            Image($r('app.media.service_icon_clean_room'))
              .width(40)
              .height(40)
              .margin({ right: 16 })

            Column() {
              Text('清理房间')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .margin({ bottom: 4 })

              Text(this.viewModel.roomModel.service.cleanRoom ? '已请求' : '未请求')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .opacity(0.7)
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ right: 20 })

            DeviceSwitch({
              isOpened: this.viewModel.roomModel.service.cleanRoom,
              onChange: (value: boolean) => {
                this.viewModel.toggleCleanRoom();
              }
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding(20)
        .borderRadius(16)
        .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
        .backgroundColor('rgba(0,0,0,0)')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [
            [0x000000, 0.7],
            [0x000000, 1.0]
          ]
        })
        .margin({ bottom: 40 })

        // SOS 紧急呼叫按钮
        Column() {
          Row() {
            Column() {
              Text('SOS')
                .fontSize(24)
              Text('????')
                .fontSize(12)
                .fontColor('#FFFFFF')
                .margin({ top: 4 })
            }
          }
          .width(120)
          .height(120)
          .borderRadius(60)
          .backgroundColor('#FF0000')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            // SOS 紧急呼叫功能
            console.info('???????');
          })
        }
        .margin({ bottom: 40 })

        // 登出按钮
        Button('????')
          .width(200)
          .height(48)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#000000')
          .backgroundColor(Color.White)
          .borderRadius(24)
          .onClick(() => {
            this.viewModel.reset();
            router.replaceUrl({
              url: 'pages/Index'
            });
          })
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [
        [0x000000, 0.9],
        [0x000000, 0.0]
      ]
    })
  }
}
