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
      Column()
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.home_background'))
        .backgroundImageSize(ImageSize.Cover)

      // 渐变遮罩
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.2)')

      Column() {
        // 顶部欢迎区域
        Row() {
          Column() {
            Image($r('app.media.home_text_smart_guest_room'))
              .width(120)
              .height(24)
              .objectFit(ImageFit.Contain)

            Text(`欢迎回家，房号: ${this.viewModel.roomModel.roomNumber}`)
              .fontSize(14)
              .fontColor('#FFFFFF')
              .opacity(0.8)
              .margin({ top: 8 })
          }
          .alignItems(HorizontalAlign.Center)
        }
        .width('90%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 50, bottom: 24 })

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
                .borderRadius(12)

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
                      Image(this.viewModel.roomModel.airConditioner.isRunning
                        ? $r('app.media.service_toggle_dots_bg')
                        : $r('app.media.home_icon_close'))
                        .width(52)
                        .height(28)
                        .objectFit(ImageFit.Contain)
                        .shadow({
                          radius: this.viewModel.roomModel.airConditioner.isRunning ? 4 : 0,
                          color: this.viewModel.roomModel.airConditioner.isRunning ? '#88FFD700' : '#00000000'
                        })
                        .onClick(() => {
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
              // 标题
              Text('场景模式')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .width('90%')
                .margin({ bottom: 12 })

              // 2x2 场景模式网格
              Grid() {
                ForEach(['bright', 'soft', 'read', 'warm'], (mode: string, index: number) => {
                  GridItem() {
                    Stack() {
                      // 背景图片
                      Image($r('app.media.home_layer_scenemode'))
                        .width('100%')
                        .height('100%')
                        .borderRadius(12)

                      // 选中状态
                      if (this.viewModel.roomModel.sceneMode === mode) {
                        Image($r('app.media.tabs_icon_bg_selected'))
                          .width('100%')
                          .height('100%')
                          .borderRadius(12)
                      }

                      Row() {
                        Image(this.getSceneIcon(mode))
                          .width(28)
                          .height(28)
                          .margin({ right: 8 })

                        Text(this.getSceneName(mode))
                          .fontSize(14)
                          .fontColor('rgb(88, 53, 23)')
                      }
                      .justifyContent(FlexAlign.Center)
                      .alignItems(VerticalAlign.Center)
                    }
                    .width('100%')
                    .height(64)
                    .onClick(() => {
                      this.viewModel.switchScene(mode);
                    })
                  }
                })
              }
              .columnsTemplate('1fr 1fr')
              .rowsTemplate('1fr 1fr')
              .columnsGap(12)
              .rowsGap(12)
              .width('100%')
              .height(140)
            }
            .width('90%')
            .margin({ bottom: 24 })

            // 快捷服务区域
            Column() {
              Text('快捷服务')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .width('90%')
                .margin({ bottom: 12 })

              // 第一行：请勿打扰 和 清理房间
              Row() {
                // 请勿打扰
                Stack() {
                  Image($r('app.media.home_layer_scenemode'))
                    .width('100%')
                    .height('100%')
                    .borderRadius(12)

                  Row() {
                    Image($r('app.media.service_icon_do_not_disturb'))
                      .width(28)
                      .height(28)
                      .objectFit(ImageFit.Contain)
                      .margin({ right: 8 })

                    Text('请勿打扰')
                      .fontSize(14)
                      .fontColor('rgb(88, 53, 23)')
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .width('48%')
                .height(64)
                .onClick(() => {
                  this.viewModel.toggleDoNotDisturb();
                })

                // 清理房间
                Stack() {
                  Image($r('app.media.home_layer_scenemode'))
                    .width('100%')
                    .height('100%')
                    .borderRadius(12)

                  Row() {
                    Image($r('app.media.service_icon_clean_room'))
                      .width(28)
                      .height(28)
                      .objectFit(ImageFit.Contain)
                      .margin({ right: 8 })

                    Text('清理房间')
                      .fontSize(14)
                      .fontColor('rgb(88, 53, 23)')
                  }
                  .width('100%')
                  .height('100%')
                  .justifyContent(FlexAlign.Center)
                }
                .width('48%')
                .height(64)
                .onClick(() => {
                  this.viewModel.toggleCleanRoom();
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ bottom: 12 })

              // 第二行：晚安模式
              Stack() {
                Image($r('app.media.home_layer_night'))
                  .width('100%')
                  .height('100%')
                  .borderRadius(12)

                Row() {
                  Image($r('app.media.home_icon_night_left'))
                    .width(28)
                    .height(28)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 8 })

                  Text('晚安模式')
                    .fontSize(14)
                    .fontColor('rgb(88, 53, 23)')

                  Blank()

                  Image($r('app.media.home_icon_night_right'))
                    .width(52)
                    .height(28)
                    .objectFit(ImageFit.Contain)
                }
                .width('90%')
                .height('100%')
              }
              .width('100%')
              .height(64)
            }
            .width('90%')
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
        return '明亮模式';
      case 'soft':
        return '柔和模式';
      case 'read':
        return '阅读模式';
      case 'warm':
        return '温馨模式';
      case 'sleep':
        return '睡眠模式';
      default:
        return '';
    }
  }
}
