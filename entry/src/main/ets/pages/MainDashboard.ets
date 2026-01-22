import { RoomViewModel } from '../viewmodel/RoomViewModel';
import { DeviceSwitch } from '../view/DeviceSwitch';
import { ControlPanel } from '../view/ControlPanel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct MainDashboard {
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
      Image($r('app.media.home_background'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Scroll() {
        Column() {
          // 顶部欢迎信息
          Row() {
            Text('智慧客房')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')

            Text(`房号: ${this.viewModel.roomModel.roomNumber}`)
              .fontSize(16)
              .fontColor('#FFFFFF')
              .opacity(0.8)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: 20, right: 20 })
          .margin({ top: 20, bottom: 20 })

          // 空调控制卡片
          Column() {
            Text('空调控制')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .margin({ bottom: 16 })

            Row() {
              // 空调开关
              DeviceSwitch({
                isOpened: this.viewModel.roomModel.airConditioner.isRunning,
                onChange: (value: boolean) => {
                  if (value !== this.viewModel.roomModel.airConditioner.isRunning) {
                    this.viewModel.toggleAirConditioner();
                  }
                }
              })

              Column() {
                Text(`${this.viewModel.roomModel.airConditioner.targetTemperature}°C`)
                  .fontSize(32)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                  .margin({ bottom: 20 })

                Row() {
                  Column()
                    .width(40)
                    .height(40)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(HorizontalAlign.Center)
                    .onClick(() => {
                      this.viewModel.updateTemperature(-1);
                    }) {
                      Image($r('app.media.home_btn_sub'))
                        .width(24)
                        .height(24)
                    }

                  Column()
                    .width(40)
                    .height(40)
                    .justifyContent(FlexAlign.Center)
                    .alignItems(HorizontalAlign.Center)
                    .onClick(() => {
                      this.viewModel.updateTemperature(1);
                    }) {
                      Image($r('app.media.home_btn_add'))
                        .width(24)
                        .height(24)
                    }
                }
              }
              .justifyContent(FlexAlign.Center)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
          }
          .width('90%')
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
          .margin({ bottom: 30, left: 20, right: 20 })

          // 场景模式选择
          Column() {
            Text('场景模式')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .margin({ bottom: 16 })

            Grid() {
              ForEach(['bright', 'soft', 'read', 'warm', 'sleep'], (mode: string) => {
                GridItem() {
                  Column() {
                    Row() {
                      Image(this.getSceneIcon(mode))
                        .width(24)
                        .height(24)
                        .margin({ right: 8 })

                      Text(this.getSceneName(mode))
                        .fontSize(14)
                        .fontColor('#FFFFFF')
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.Center)

                    // 选中状态指示
                    if (this.viewModel.roomModel.sceneMode === mode) {
                      Image($r('app.media.tabs_bg'))
                        .width(40)
                        .height(4)
                        .margin({ top: 8 })
                    }
                  }
                  .width('100%')
                  .height(80)
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
                  .border({ width: 1, color: 'rgba(0,0,0,0)' })
                  .onClick(() => {
                    this.viewModel.switchScene(mode);
                  })
                }
              })
            }
            .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
            .rowsTemplate('1fr')
            .width('100%')
            .height(100)
            .borderRadius(16)
          }
          .width('90%')
          .padding({ left: 20, right: 20 })
          .margin({ bottom: 30, left: 20, right: 20 })

          // 快捷服务按钮
          Row() {
            Button('灯光控制')
              .width(120)
              .height(45)
              .fontSize(16)
              .fontColor('#000000')
              .backgroundColor(Color.White)
              .borderRadius(22)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/LightControl',
                  params: {
                    roomNumber: this.viewModel.roomModel.roomNumber
                  }
                });
              })

            Button('窗帘控制')
              .width(120)
              .height(45)
              .fontSize(16)
              .fontColor('#000000')
              .backgroundColor(Color.White)
              .borderRadius(22)
              .margin({ left: 20, right: 20 })
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/CurtainControl',
                  params: {
                    roomNumber: this.viewModel.roomModel.roomNumber
                  }
                });
              })

            Button('服务控制')
              .width(120)
              .height(45)
              .fontSize(16)
              .fontColor('#000000')
              .backgroundColor(Color.White)
              .borderRadius(22)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ServiceControl',
                  params: {
                    roomNumber: this.viewModel.roomModel.roomNumber
                  }
                });
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 40 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 获取场景图标
   */
  private getSceneIcon(mode: string): Resource {
    switch (mode) {
      case 'bright':
        return $r('app.media.home_icon_bright');
      case 'soft':
        return $r('app.media.home_icon_soft');
      case 'read':
        return $r('app.media.home_icon_read');
      case 'warm':
        return $r('app.media.home_icon_warm');
      case 'sleep':
        return $r('app.media.home_icon_night_left');
      default:
        return $r('app.media.home_icon_bright'); // 提供默认图标
    }
  }

  /**
   * 获取场景名称
   */
  private getSceneName(mode: string): string {
    switch (mode) {
      case 'bright':
        return '明亮';
      case 'soft':
        return '柔和';
      case 'read':
        return '阅读';
      case 'warm':
        return '温馨';
      case 'sleep':
        return '睡眠';
      default:
        return '';
    }
  }
}
