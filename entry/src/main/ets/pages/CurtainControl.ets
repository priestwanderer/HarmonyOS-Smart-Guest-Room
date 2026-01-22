import { RoomViewModel } from '../viewmodel/RoomViewModel';
import { DeviceSwitch } from '../view/DeviceSwitch';
import { ControlPanel } from '../view/ControlPanel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct CurtainControl {
  @Local viewModel: RoomViewModel = new RoomViewModel();
  @Param roomNumber: string = '';
  @Local curtainProgress: number = 0;

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
      Image($r('app.media.curtain_bg'))
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

          Text('窗帘控制')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 20, right: 20 })
        .margin({ top: 20, bottom: 40 })

        // 窗帘视觉展示
        Stack() {
          // 背景窗纱（关闭状态）
          if (this.viewModel.roomModel.curtain.screenOpen < 50) {
            Row() {
              Image($r('app.media.curtain_icon_window_screening_left_part_closed'))
                .width('45%')
                .height('100%')
                .objectFit(ImageFit.Cover)

              Image($r('app.media.curtain_icon_window_screening_right_part_closed'))
                .width('45%')
                .height('100%')
                .objectFit(ImageFit.Cover)
            }
            .width('100%')
            .height('60%')
          }

          // 窗帘状态展示
          Row() {
            // 左侧窗帘
            Image($r('app.media.curtain_icon_left_part'))
              .width(this.getCurtainWidth(true))
              .height('100%')
              .objectFit(ImageFit.Cover)

            // 中间空隙
            Column()
              .width(this.getGapWidth())
              .height('100%')

            // 右侧窗帘
            Image($r('app.media.curtain_icon_right_part'))
              .width(this.getCurtainWidth(false))
              .height('100%')
              .objectFit(ImageFit.Cover)
          }
          .width('100%')
          .height('60%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .height(300)
        .backgroundColor('rgba(0,0,0,0)')
        .margin({ bottom: 40 })

        // 控制按钮
        Row() {
          Column() {
            Image($r('app.media.curtain_icon_open'))
              .width(48)
              .height(48)
              .margin({ bottom: 8 })
              .onClick(() => {
                this.viewModel.openCurtain();
              })

            Text('打开')
              .fontSize(14)
              .fontColor('#FFFFFF')
          }
          .width(100)
          .height(100)
          .borderRadius(12)
          .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [
              [0x000000, 0.0],
              [0x000000, 1.0]
            ]
          })
          .borderRadius(12)

          Column() {
            Image($r('app.media.curtain_icon_pause'))
              .width(48)
              .height(48)
              .margin({ bottom: 8 })
              .onClick(() => {
                // 暂停当前窗帘运动（这里可以添加动画暂停逻辑）
              })

            Text('暂停')
              .fontSize(14)
              .fontColor('#FFFFFF')
          }
          .width(100)
          .height(100)
          .borderRadius(12)
          .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [
              [0x000000, 0.6],
              [0x000000, 0.3]
            ]
          })
          .borderRadius(12)
          .margin({ left: 30, right: 30 })

          Column() {
            Image($r('app.media.curtain_icon_close'))
              .width(48)
              .height(48)
              .margin({ bottom: 8 })
              .onClick(() => {
                this.viewModel.closeCurtain();
              })

            Text('关闭')
              .fontSize(14)
              .fontColor('#FFFFFF')
          }
          .width(100)
          .height(100)
          .borderRadius(12)
          .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [
              [0x000000, 0.6],
              [0x000000, 1.0]
            ]
          })
          .borderRadius(12)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)

        // 窗帘开合滑块
        Column() {
          Text(`开合程度: ${this.viewModel.roomModel.curtain.curtainOpen}%`)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .margin({ bottom: 16 })

          Slider({
            value: this.viewModel.roomModel.curtain.curtainOpen,
            min: 0,
            max: 100,
            style: SliderStyle.OutSet
          })
            .width('90%')
            .trackColor('rgba(255,255,255,0.3)')
            .selectedColor(Color.White)
            .blockColor(Color.White)
            .onChange((value: number) => {
              this.viewModel.setCurtainState(value);
            })
        }
        .width('100%')
        .margin({ top: 40 })
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
        [0x000000, 1.0]
      ]
    })
  }

  /**
   * 获取窗帘宽度
   */
  private getCurtainWidth(isLeft: boolean): string {
    const openPercentage = this.viewModel.roomModel.curtain.curtainOpen;
    const baseWidth = 45; // 基础宽度百分比
    const actualWidth = isLeft
      ? baseWidth - (openPercentage / 2)
      : baseWidth - (openPercentage / 2);
    return `${actualWidth}%`;
  }

  /**
   * 获取中间空隙宽度
   */
  private getGapWidth(): string {
    const openPercentage = this.viewModel.roomModel.curtain.curtainOpen;
    return `${openPercentage}%`;
  }
}
