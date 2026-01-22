import { RoomViewModel } from '../viewmodel/RoomViewModel';
import { LightState } from '../model/RoomModel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct LightControl {
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
      Image($r('app.media.light_bg'))
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
            [0x000000, 0.9],
            [0x000000, 0.0]
          ]
        })

      Column() {
        // 顶部导航
        Row() {
          Image($r('app.media.light_icon_back'))
            .width(24)
            .height(24)
            .onClick(() => {
              router.back();
            })

          Text('灯光控制')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 40, bottom: 20 })

        Scroll() {
          Column() {
            // 主开关区域
            Column() {
              // 主开关背景图
              Image($r('app.media.light_btn_main_switch'))
                .width('100%')
                .height(120)
                .objectFit(ImageFit.Cover)
                .borderRadius(16)

              // 主开关内容覆盖
              Row() {
                Column() {
                  Text('主开关')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#FFFFFF')
                    .margin({ bottom: 12 })

                  // 主开关Toggle
                  Toggle({ type: ToggleType.Switch, isOn: this.viewModel.roomModel.lights.some(light => light.isOpened) })
                    .selectedColor('#FFD700')
                    .width(60)
                    .height(32)
                    .onChange((value: boolean) => {
                      this.viewModel.toggleAllLights(value);
                    })
                }
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)
              .position({ left: 0, top: 0 })
            }
            .width('90%')
            .height(120)
            .margin({ bottom: 30 })

            // 场景模式区域
            Column() {
              Text('场景模式')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .margin({ bottom: 16 })
                .alignSelf(ItemAlign.Start)

              // 场景模式网格
              Grid() {
                ForEach(['bright', 'soft', 'read', 'warm', 'sleep'], (mode: string) => {
                  GridItem() {
                    Column() {
                      Image(this.getSceneIcon(mode))
                        .width(40)
                        .height(40)
                        .margin({ bottom: 8 })

                      Text(this.getSceneName(mode))
                        .fontSize(14)
                        .fontColor('#FFFFFF')

                      // 选中状态指示点
                      if (this.viewModel.roomModel.sceneMode === mode) {
                        Image($r('app.media.tabs_bg'))
                          .width(40)
                          .height(4)
                          .margin({ top: 8 })
                      }
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
              .height(100)
            }
            .width('90%')
            .margin({ bottom: 30 })

            // 独立控制区域
            Column() {
              Text('独立控制')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .margin({ bottom: 16 })
                .alignSelf(ItemAlign.Start)

              // 独立控制网格背景
              Image($r('app.media.light_Independent_control_bg'))
                .width('100%')
                .height(320)
                .objectFit(ImageFit.Cover)
                .borderRadius(16)

              // 网格内容
              Grid() {
                ForEach(this.viewModel.roomModel.lights, (light: LightState) => {
                  GridItem() {
                    Column() {
                      // 图标
                      Image(this.getLightIcon(light.name))
                        .width(40)
                        .height(40)
                        .margin({ bottom: 8 })

                      // 名称
                      Text(light.name)
                        .fontSize(14)
                        .fontColor('#FFFFFF')

                      // 开关
                      Toggle({ type: ToggleType.Switch, isOn: light.isOpened })
                        .selectedColor('#FFD700')
                        .width(44)
                        .height(24)
                        .onChange((value: boolean) => {
                          this.viewModel.setLightState(light.id, value);
                        })
                    }
                    .width('100%')
                    .height(100)
                    .justifyContent(FlexAlign.Center)
                    .align(Alignment.Center)
                  }
                })
              }
              .columnsTemplate('1fr 1fr')
              .rowsTemplate('1fr 1fr 1fr')
              .width('90%')
              .height(300)
              .position({ left: '5%', top: 10 })
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
            Image($r('app.media.tabs_icon_home_unselect'))
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
          .onClick(() => {
            router.pushUrl({ url: 'pages/MainDashboard' }).catch((err: Error) => {
              console.error('Navigation failed:', err.message);
            });
          })

          // 灯光
          Column() {
            Image($r('app.media.tabs_icon_light_select'))
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
   * 获取灯光图标
   */
  private getLightIcon(name: string): Resource {
    switch (name) {
      case '洗手间':
        return $r('app.media.light_icon_washroom');
      case '衣柜':
        return $r('app.media.light_icon_wardrobe');
      case '落地灯':
        return $r('app.media.light_icon_bar_lamp');
      case '吧灯':
        return $r('app.media.light_icon_bar_lamp');
      case '书桌灯':
        return $r('app.media.light_icon_right_left_desk_read');
      case '左阅读灯':
        return $r('app.media.light_icon_right_left_desk_read');
      case '右阅读灯':
        return $r('app.media.light_icon_right_left_desk_read');
      case '走廊':
        return $r('app.media.light_icon_corrid_lights');
      case '排风扇':
        return $r('app.media.light_icon_exhaust_fan');
      default:
        return $r('app.media.light_icon_soft');
    }
  }

  /**
   * 获取场景图标
   */
  private getSceneIcon(mode: string): Resource {
    switch (mode) {
      case 'bright':
        return $r('app.media.light_icon_bright_mode');
      case 'soft':
        return $r('app.media.light_icon_soft');
      case 'read':
        return $r('app.media.light_icon_read_mode');
      case 'warm':
        return $r('app.media.light_icon_warm_mode');
      case 'sleep':
        return $r('app.media.light_icon_sleep_mode');
      default:
        return $r('app.media.light_icon_soft');
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
