import { RoomViewModel } from '../viewmodel/RoomViewModel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct CurtainControl {
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
      Image($r('app.media.curtain_bg'))
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

          Text('窗帘控制')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 40, bottom: 20 })

        Scroll() {
          Column() {
            // 窗帘视觉展示区域
            Column() {
              // 顶部横杆
              Image($r('app.media.curtain_icon_top_bar'))
                .width('80%')
                .height(20)
                .margin({ bottom: 10 })

              // 窗帘主体
              Stack() {
                // 窗纱背景（关闭状态）
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
                  .height('100%')
                }

                // 窗帘状态展示
                Row() {
                  // 左侧窗帘
                  Image(this.viewModel.roomModel.curtain.curtainOpen > 50
                    ? $r('app.media.curtain_icon_left_part')
                    : $r('app.media.curtain_icon_left_closed'))
                    .width(this.getCurtainWidth(true))
                    .height('100%')
                    .objectFit(ImageFit.Cover)
                    .transition(TransitionEffect.OPACITY)

                  // 中间空隙
                  Column()
                    .width(this.getGapWidth())
                    .height('100%')

                  // 右侧窗帘
                  Image(this.viewModel.roomModel.curtain.curtainOpen > 50
                    ? $r('app.media.curtain_icon_right_part')
                    : $r('app.media.curtain_icon_right_closed'))
                    .width(this.getCurtainWidth(false))
                    .height('100%')
                    .objectFit(ImageFit.Cover)
                    .transition(TransitionEffect.OPACITY)
                }
                .width('100%')
                .height(250)
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .width('100%')
              .height(250)
              .backgroundColor('rgba(0,0,0,0)')
            }
            .width('90%')
            .height(280)
            .margin({ bottom: 30 })

            // 窗帘控制区域
            Column() {
              // 窗帘控制按钮
              Row() {
                // 全部打开
                Column() {
                  Image($r('app.media.curtain_icon_open_all'))
                    .width(48)
                    .height(48)
                    .margin({ bottom: 8 })

                  Text('打开')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                }
                .width(90)
                .height(100)
                .borderRadius(16)
                .justifyContent(FlexAlign.Center)
                .align(Alignment.Center)
                .backgroundImage($r('app.media.curtain_btn_all_open_or_close_selected_bg'))
                .backgroundImageSize(ImageSize.Cover)
                .onClick(() => {
                  this.viewModel.openCurtain();
                })

                // 暂停
                Column() {
                  Image($r('app.media.curtain_icon_open'))
                    .width(48)
                    .height(48)
                    .margin({ bottom: 8 })

                  Text('暂停')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                }
                .width(90)
                .height(100)
                .borderRadius(16)
                .justifyContent(FlexAlign.Center)
                .align(Alignment.Center)
                .backgroundImage($r('app.media.curtain_btn_unselected_bg'))
                .backgroundImageSize(ImageSize.Cover)
                .margin({ left: 20, right: 20 })
                .onClick(() => {
                  // 暂停当前窗帘运动
                })

                // 全部关闭
                Column() {
                  Image($r('app.media.curtain_icon_close_all'))
                    .width(48)
                    .height(48)
                    .margin({ bottom: 8 })

                  Text('关闭')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                }
                .width(90)
                .height(100)
                .borderRadius(16)
                .justifyContent(FlexAlign.Center)
                .align(Alignment.Center)
                .backgroundImage($r('app.media.curtain_btn_selected_bg'))
                .backgroundImageSize(ImageSize.Cover)
                .onClick(() => {
                  this.viewModel.closeCurtain();
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ bottom: 30 })

              // 纱窗控制区域
              Column() {
                Text('窗纱控制')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')
                  .margin({ bottom: 16 })
                  .alignSelf(ItemAlign.Start)

                Row() {
                  // 纱窗打开
                  Column() {
                    Image($r('app.media.curtain_icon_window_screening_left_part'))
                      .width(48)
                      .height(48)
                      .margin({ bottom: 8 })

                    Text('打开')
                      .fontSize(14)
                      .fontColor('#FFFFFF')
                  }
                  .width(90)
                  .height(100)
                  .borderRadius(16)
                  .justifyContent(FlexAlign.Center)
                  .align(Alignment.Center)
                  .backgroundImage($r('app.media.curtain_window_screening_part_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .onClick(() => {
                    this.viewModel.openScreen();
                  })

                  // 纱窗关闭
                  Column() {
                    Image($r('app.media.curtain_icon_window_screening_right_part'))
                      .width(48)
                      .height(48)
                      .margin({ bottom: 8 })

                    Text('关闭')
                      .fontSize(14)
                      .fontColor('#FFFFFF')
                  }
                  .width(90)
                  .height(100)
                  .borderRadius(16)
                  .justifyContent(FlexAlign.Center)
                  .align(Alignment.Center)
                  .backgroundImage($r('app.media.curtain_window_screening_part_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .margin({ left: 20, right: 20 })
                  .onClick(() => {
                    this.viewModel.closeScreen();
                  })
                }
                .width('100%')
                .justifyContent(FlexAlign.Center)
              }
              .width('90%')
              .margin({ bottom: 30 })

              // 窗帘开合程度滑块
              Column() {
                Row() {
                  Text('窗帘开合程度:')
                    .fontSize(16)
                    .fontColor('#FFFFFF')
                    .margin({ right: 8 })

                  Text(`${this.viewModel.roomModel.curtain.curtainOpen}%`)
                    .fontSize(16)
                    .fontColor('#FFD700')
                }
                .margin({ bottom: 12 })
                .alignSelf(ItemAlign.Start)

                Slider({
                  value: this.viewModel.roomModel.curtain.curtainOpen,
                  min: 0,
                  max: 100,
                  style: SliderStyle.OutSet
                })
                  .width('100%')
                  .trackColor('rgba(255,255,255,0.3)')
                  .selectedColor('#FFD700')
                  .blockColor('#FFFFFF')
                  .onChange((value: number) => {
                    this.viewModel.setCurtainState(value);
                  })
              }
              .width('90%')
              .margin({ bottom: 40 })
            }
            .width('90%')
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
            Image($r('app.media.tabs_icon_curtain_select'))
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
   * 获取窗帘宽度
   */
  private getCurtainWidth(isLeft: boolean): string {
    const openPercentage = this.viewModel.roomModel.curtain.curtainOpen;
    const baseWidth = 45;
    const actualWidth = isLeft
      ? baseWidth - (openPercentage / 2)
      : baseWidth - (openPercentage / 2);
    return `${Math.max(5, actualWidth)}%`;
  }

  /**
   * 获取中间空隙宽度
   */
  private getGapWidth(): string {
    const openPercentage = this.viewModel.roomModel.curtain.curtainOpen;
    return `${openPercentage}%`;
  }
}
