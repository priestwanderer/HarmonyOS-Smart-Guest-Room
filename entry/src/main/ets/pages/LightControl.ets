import { RoomViewModel } from '../viewmodel/RoomViewModel';
import { LightState } from '../model/RoomModel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct LightControl {
  @Local viewModel: RoomViewModel = new RoomViewModel();
  @Param roomNumber: string = '';

  // 静态灯光列表 - 使用@Local使其响应式
  @Local lights: LightState[] = [
    this.createLight('1', '洗漱间', false),
    this.createLight('2', '衣柜灯', false),
    this.createLight('3', '落地灯', false),
    this.createLight('4', '吧灯', false),
    this.createLight('5', '书桌灯', false),
    this.createLight('6', '左阅读灯', false),
    this.createLight('7', '右阅读灯', false),
    this.createLight('8', '排风扇', false),
    this.createLight('9', '廊灯', false),
  ];

  private createLight(id: string, name: string, isOpened: boolean): LightState {
    const light = new LightState();
    light.id = id;
    light.name = name;
    light.isOpened = isOpened;
    return light;
  }

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
        .backgroundImage($r('app.media.light_bg'))
        .backgroundImageSize(ImageSize.Cover)

      // 渐变遮罩
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.2)')

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
              Image($r('app.media.light_btn_main_switch'))
                .width(160)
                .height(100)
                .objectFit(ImageFit.Contain)
                .onClick(() => {
                  const anyOn = this.viewModel.roomModel.lights.some(light => light.isOpened);
                  this.viewModel.toggleAllLights(!anyOn);
                })

              Text('总开关')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .margin({ top: 8 })
            }
            .width('90%')
            .margin({ bottom: 24 })

            // 场景模式区域 - 毛玻璃背景
            Column() {
              Text('场景模式')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .margin({ bottom: 12 })
                .alignSelf(ItemAlign.Start)

              // 2x3 Grid布局 (5个模式)
              Grid() {
                ForEach(['bright', 'soft', 'read', 'warm', 'sleep'], (mode: string) => {
                  GridItem() {
                    Stack() {
                      // 模式背景图
                      Image($r('app.media.light_btn_mode_bg'))
                        .width('100%')
                        .height('100%')
                        .position({ left: 0, top: 0 })
                        .objectFit(ImageFit.Cover)
                        .borderRadius(12)

                      // 选中状态
                      if (this.viewModel.roomModel.sceneMode === mode) {
                        Image($r('app.media.tabs_icon_bg_selected'))
                          .width('100%')
                          .height('100%')
                          .position({ left: 0, top: 0 })
                          .borderRadius(12)
                      }

                      Row() {
                        Image(this.getSceneIcon(mode))
                          .width(24)
                          .height(24)
                          .margin({ right: 8 })

                        Text(this.getSceneName(mode) + '模式')
                          .fontSize(14)
                          .fontColor('#FFFFFF')
                      }
                      .width('100%')
                      .height('100%')
                      .justifyContent(FlexAlign.Center)
                      .alignItems(VerticalAlign.Center)
                      .padding({ left: 16, right: 16 })
                    }
                    .width('100%')
                    .height(56)
                    .onClick(() => {
                      this.viewModel.switchScene(mode);
                    })
                  }
                })
              }
              .columnsTemplate('1fr 1fr')
              .rowsTemplate('1fr 1fr 1fr')
              .columnsGap(12)
              .rowsGap(12)
              .width('100%')
              .height(180)
            }
            .width('90%')
            .padding(16)
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .backdropBlur(25)
            .borderRadius(16)
            .margin({ bottom: 24 })

            // 独立控制区域 - 毛玻璃背景
            Column() {
              Text('独立控制')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#FFFFFF')
                .margin({ bottom: 12 })
                .alignSelf(ItemAlign.Start)

              // 2列Grid布局
              Grid() {
                ForEach(this.lights, (light: LightState) => {
                  GridItem() {
                    Row() {
                      // 图标
                      Image(this.getLightIcon(light.name))
                        .width(28)
                        .height(28)
                        .objectFit(ImageFit.Contain)

                      // 名称
                      Text(light.name)
                        .fontSize(14)
                        .fontColor('#FFFFFF')
                        .margin({ left: 8 })

                      Blank()

                      // 开关图片
                      Image(light.isOpened
                        ? $r('app.media.light_toggle_on')
                        : $r('app.media.light_toggle_off'))
                        .width(44)
                        .height(24)
                        .objectFit(ImageFit.Contain)
                        .onClick(() => {
                          // 直接修改@ObservedV2对象的属性
                          light.isOpened = !light.isOpened;
                        })
                    }
                    .width('100%')
                    .height(48)
                    .justifyContent(FlexAlign.Center)
                  }
                })
              }
              .columnsTemplate('1fr 1fr')
              .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
              .columnsGap(12)
              .rowsGap(12)
              .width('100%')
              .height(300)
            }
            .width('90%')
            .padding(16)
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .backdropBlur(25)
            .borderRadius(16)
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
      case '洗漱间':
        return $r('app.media.light_icon_washroom');
      case '衣柜灯':
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
      case '排风扇':
        return $r('app.media.light_icon_exhaust_fan');
      case '廊灯':
        return $r('app.media.light_icon_corrid_lights');
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
