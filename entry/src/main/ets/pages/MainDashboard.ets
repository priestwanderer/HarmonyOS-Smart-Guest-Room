import { RoomViewModel } from '../viewmodel/RoomViewModel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct MainDashboard {
  @Local viewModel: RoomViewModel = new RoomViewModel();
  @Param roomNumber: string = '';
  @Local selectedTab: number = 0; // 0=首页, 1=灯光, 2=窗帘, 3=服务

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

      // 渐变遮罩
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [
            [0x000000, 0.3],
            [0x000000, 0.0]
          ]
        })

      Column() {
        // 顶部欢迎区域
        Row() {
          Column() {
            Text('智慧客房')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')

            Text(`房号: ${this.viewModel.roomModel.roomNumber}`)
              .fontSize(14)
              .fontColor('#FFFFFF')
              .opacity(0.8)
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Center)

          // SOS按钮
          Column() {
            Text('SOS')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
          }
          .width(60)
          .height(60)
          .borderRadius(30)
          .backgroundColor('#FF3333')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/ServiceControl' }).catch((err: Error) => {
              console.error('Navigation failed:', err.message);
            });
          })
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .margin({ top: 40, bottom: 20 })

        // 主内容区域
        Scroll() {
          Column() {
            // 空调控制卡片
            Column() {
              // 卡片背景
              Image($r('app.media.home_layer_airconditioner'))
                .width('100%')
                .height('100%')
                .position({ left: 0, top: 0 })
                .objectFit(ImageFit.Cover)

              // 空调内容
              Column() {
                Row() {
                  // 左侧：空调图标和状态
                  Column() {
                    Image($r('app.media.home_icon_airconditioner'))
                      .width(60)
                      .height(60)

                    Text(this.viewModel.roomModel.airConditioner.isRunning ? '空调运行中' : '空调已关闭')
                      .fontSize(14)
                      .fontColor('#FFFFFF')
                      .margin({ top: 8 })

                    // 空调开关
                    Row() {
                      Text(this.viewModel.roomModel.airConditioner.isRunning ? '开' : '关')
                        .fontSize(14)
                        .fontColor('#FFFFFF')
                        .margin({ right: 8 })

                      Toggle({ type: ToggleType.Switch, isOn: this.viewModel.roomModel.airConditioner.isRunning })
                        .selectedColor('#FFD700')
                        .width(44)
                        .height(24)
                        .onChange((value: boolean) => {
                          this.viewModel.toggleAirConditioner();
                        })
                    }
                    .margin({ top: 12 })
                  }
                  .width('45%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)

                  // 右侧：温度控制
                  Column() {
                    // 温度显示
                    Text(`${this.viewModel.roomModel.airConditioner.targetTemperature}°C`)
                      .fontSize(40)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#FFFFFF')

                    // 温度调节按钮
                    Row() {
                      // 减温按钮
                      Image($r('app.media.home_btn_sub'))
                        .width(36)
                        .height(36)
                        .onClick(() => {
                          this.viewModel.updateTemperature(-1);
                        })

                      // 加温按钮
                      Image($r('app.media.home_btn_add'))
                        .width(36)
                        .height(36)
                        .margin({ left: 20 })
                        .onClick(() => {
                          this.viewModel.updateTemperature(1);
                        })
                    }
                    .margin({ top: 12 })
                  }
                  .width('55%')
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                }
                .width('100%')
              }
              .width('100%')
              .padding(20)
            }
            .width('90%')
            .height(180)
            .borderRadius(16)
            .margin({ bottom: 30 })

            // 场景模式区域
            Column() {
              Text('场景模式')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .margin({ bottom: 16 })

              // 场景模式网格
              Grid() {
                ForEach(['bright', 'soft', 'read', 'warm', 'sleep'], (mode: string, index: number) => {
                  GridItem() {
                    Column() {
                      // 背景选中状态
                      if (this.viewModel.roomModel.sceneMode === mode) {
                        Image($r('app.media.tabs_bg'))
                          .width('100%')
                          .height('100%')
                          .position({ left: 0, top: 0 })
                          .objectFit(ImageFit.Cover)
                      }

                      Image(this.getSceneIcon(mode))
                        .width(32)
                        .height(32)
                        .margin({ bottom: 8 })

                      Text(this.getSceneName(mode))
                        .fontSize(14)
                        .fontColor('#FFFFFF')
                    }
                    .width('100%')
                    .height(80)
                    .justifyContent(FlexAlign.Center)
                    .align(Alignment.Center)
                    .onClick(() => {
                      this.viewModel.switchScene(mode);
                    })
                  }
                })
              }
              .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
              .rowsTemplate('1fr')
              .width('100%')
              .height(90)
            }
            .width('90%')
            .margin({ bottom: 30 })

            // 快捷功能按钮
            Row() {
              // 灯光按钮
              Column() {
                Image($r('app.media.tabs_icon_light_select'))
                  .width(40)
                  .height(40)
                Text('灯光控制')
                  .fontSize(14)
                  .fontColor('#FFFFFF')
                  .margin({ top: 8 })
              }
              .width(90)
              .height(100)
              .borderRadius(16)
              .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                router.pushUrl({ url: 'pages/LightControl' }).catch((err: Error) => {
                  console.error('Navigation failed:', err.message);
                });
              })

              // 窗帘按钮
              Column() {
                Image($r('app.media.tabs_icon_curtain_select'))
                  .width(40)
                  .height(40)
                Text('窗帘控制')
                  .fontSize(14)
                  .fontColor('#FFFFFF')
                  .margin({ top: 8 })
              }
              .width(90)
              .height(100)
              .borderRadius(16)
              .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
              .justifyContent(FlexAlign.Center)
              .margin({ left: 15, right: 15 })
              .onClick(() => {
                router.pushUrl({ url: 'pages/CurtainControl' }).catch((err: Error) => {
                  console.error('Navigation failed:', err.message);
                });
              })

              // 服务按钮
              Column() {
                Image($r('app.media.tabs_icon_service_select'))
                  .width(40)
                  .height(40)
                Text('服务控制')
                  .fontSize(14)
                  .fontColor('#FFFFFF')
                  .margin({ top: 8 })
              }
              .width(90)
              .height(100)
              .borderRadius(16)
              .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                router.pushUrl({ url: 'pages/ServiceControl' }).catch((err: Error) => {
                  console.error('Navigation failed:', err.message);
                });
              })
            }
            .width('90%')
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: 40 })
          }
        }
        .width('100%')
        .layoutWeight(1)
        .scrollBar(BarState.Off)

        // 底部导航栏
        Row() {
          // 首页
          Column() {
            Image($r('app.media.tabs_icon_home_select'))
              .width(32)
              .height(32)
            Text('首页')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .margin({ top: 4 })
          }
          .width('25%')
          .height(60)
          .justifyContent(FlexAlign.Center)

          // 灯光
          Column() {
            Image($r('app.media.tabs_icon_light_unselect'))
              .width(32)
              .height(32)
            Text('灯光')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .margin({ top: 4 })
          }
          .width('25%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/LightControl' }).catch((err: Error) => {
              console.error('Navigation failed:', err.message);
            });
          })

          // 窗帘
          Column() {
            Image($r('app.media.tabs_icon_curtain_unselect'))
              .width(32)
              .height(32)
            Text('窗帘')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .margin({ top: 4 })
          }
          .width('25%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/CurtainControl' }).catch((err: Error) => {
              console.error('Navigation failed:', err.message);
            });
          })

          // 服务
          Column() {
            Image($r('app.media.tabs_icon_service_unselect'))
              .width(32)
              .height(32)
            Text('服务')
              .fontSize(12)
              .fontColor('#FFFFFF')
              .margin({ top: 4 })
          }
          .width('25%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            router.pushUrl({ url: 'pages/ServiceControl' }).catch((err: Error) => {
              console.error('Navigation failed:', err.message);
            });
          })
        }
        .width('100%')
        .height(80)
        .backgroundImage($r('app.media.tabs_bg'))
        .backgroundImageSize(ImageSize.Cover)
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .height('100%')
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
        return $r('app.media.home_icon_bright');
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
