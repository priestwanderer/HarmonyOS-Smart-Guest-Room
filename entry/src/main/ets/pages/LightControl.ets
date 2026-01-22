import { RoomViewModel } from '../viewmodel/RoomViewModel';
import { DeviceSwitch } from '../view/DeviceSwitch';
import { ControlPanel } from '../view/ControlPanel';
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

          Text('灯光控制')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 20, right: 20 })
        .margin({ top: 20, bottom: 20 })

        // 主开关
        Column() {
          Text('主开关')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .margin({ bottom: 20 })

          DeviceSwitch({
            isOpened: this.viewModel.roomModel.lights.some(light => light.isOpened),
            onChange: (value: boolean) => {
              this.viewModel.toggleAllLights(value);
            }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 40 })

        // 空调控制
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
                this.viewModel.toggleAirConditioner();
              }
            })
            .margin({ right: 20 })

            // 温度显示和调节
            Column() {
              Text(`${this.viewModel.roomModel.airConditioner.targetTemperature}°C`)
                .fontSize(32)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')

              Row() {
                // 减温按钮
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

                // 加温按钮
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
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 40 })

        // 场景模式选择
        Column() {
          Text('场景模式')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .margin({ bottom: 16 })

          Row() {
            ForEach(['bright', 'soft', 'read', 'warm', 'sleep'], (mode: string) => {
              Column() {
                Image(this.getSceneIcon(mode))
                  .width(40)
                  .height(40)
                  .margin({ bottom: 8 })

                Text(this.getSceneName(mode))
                  .fontSize(14)
                  .fontColor('#FFFFFF')
              }
              .width('18%')
              .height(80)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .borderRadius(12)
              .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
              .linearGradient({
                direction: GradientDirection.Bottom,
                colors: [
                  [0x000000, 0.6],
                  [0x000000, 0.3]
                ]
              })
              .border({ width: 1, color: this.viewModel.roomModel.sceneMode === mode ? '#FFD700' : 'rgba(0,0,0,0)' })
              .onClick(() => {
                this.viewModel.switchScene(mode);
              })
            })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: '1%', right: '1%' })
        }
        .margin({ bottom: 40 })

        // 独立灯光控制
        Column() {
          Text('独立控制')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .margin({ bottom: 16 })

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
                  DeviceSwitch({
                    isOpened: light.isOpened,
                    onChange: (value: boolean) => {
                      this.viewModel.toggleLight(light.id);
                    }
                  })
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .borderRadius(12)
                .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
                .linearGradient({
                  direction: GradientDirection.Bottom,
                  colors: [
                    [0x000000, 0.6],
                    [0x000000, 0.3]
                  ]
                })
              }
            })
          }
          .columnsTemplate('1fr 1fr')
          .rowsTemplate('1fr 1fr 1fr')
          .width('95%')
          .height(320)
          .borderRadius(16)
          .margin({ left: '2.5%', right: '2.5%' })
        }
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
      case '走廊':
        return $r('app.media.light_icon_corrid_lights');
      case '阅读灯':
        return $r('app.media.light_icon_right_left_desk_read');
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
