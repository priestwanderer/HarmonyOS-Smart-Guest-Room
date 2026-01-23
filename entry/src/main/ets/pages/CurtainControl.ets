import { RoomViewModel } from '../viewmodel/RoomViewModel';
import router from '@ohos.router';

@Entry
@ComponentV2
struct CurtainControl {
  @Local viewModel: RoomViewModel = new RoomViewModel();
  @Param roomNumber: string = '';

  // 窗帘状态（0-100）
  @Local curtainOpen: number = 0;
  // 窗纱状态（0-100）
  @Local screenOpen: number = 0;

  async aboutToAppear() {
    await this.viewModel.init(getContext());
    if (this.roomNumber) {
      this.viewModel.setRoomNumber(this.roomNumber);
    }
    await this.viewModel.loadRoomState();
    // 初始化状态
    this.curtainOpen = this.viewModel.roomModel.curtain.curtainOpen;
    this.screenOpen = this.viewModel.roomModel.curtain.screenOpen;
  }

  // 设置窗帘状态
  setCurtainState(value: number): void {
    this.curtainOpen = value;
    this.viewModel.setCurtainState(value);
  }

  // 设置窗纱状态
  setScreenState(value: number): void {
    this.screenOpen = value;
    this.viewModel.setScreenState(value);
  }

  build() {
    Stack() {
      // 背景图片
      Column()
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.curtain_bg'))
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
            // 模块一：全部打开/关闭按钮
            Row() {
              // 全部打开按钮
              Column() {
                Row() {
                  Image($r('app.media.curtain_icon_open_all'))
                    .width(24)
                    .height(24)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 8 })

                  Text('全部打开')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                }
              }
              .width('48%')
              .height(56)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .backgroundImage($r('app.media.curtain_btn_all_open_or_close_selected_bg'))
              .backgroundImageSize(ImageSize.Contain)
              .backgroundImagePosition(Alignment.Center)
              .borderRadius(12)
              .onClick(() => {
                this.curtainOpen = 100;
                this.screenOpen = 100;
                this.viewModel.openCurtain();
                this.viewModel.openScreen();
              })

              // 全部关闭按钮
              Column() {
                Row() {
                  Image($r('app.media.curtain_icon_close_all'))
                    .width(24)
                    .height(24)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 8 })

                  Text('全部关闭')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                }
              }
              .width('48%')
              .height(56)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .backgroundImage($r('app.media.curtain_btn_all_open_or_close_selected_bg'))
              .backgroundImageSize(ImageSize.Contain)
              .backgroundImagePosition(Alignment.Center)
              .borderRadius(12)
              .onClick(() => {
                this.curtainOpen = 0;
                this.screenOpen = 0;
                this.viewModel.closeCurtain();
                this.viewModel.closeScreen();
              })
            }
            .width('90%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding(16)
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .backdropBlur(25)
            .borderRadius(16)
            .margin({ bottom: 24 })

            // 模块二：布帘部分
            Column() {
              // 布帘标签
              Text('布帘')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 8 })

              // 顶部横杆
              Image($r('app.media.curtain_icon_top_bar'))
                .width('100%')
                .height(20)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 0 })

              // 窗帘状态展示
              Row() {
                // 左侧窗帘
                Image(this.curtainOpen > 50
                  ? $r('app.media.curtain_icon_left_part')
                  : $r('app.media.curtain_icon_left_closed'))
                  .width('45%')
                  .height(180)
                  .objectFit(ImageFit.Cover)

                // 右侧窗帘
                Image(this.curtainOpen > 50
                  ? $r('app.media.curtain_icon_right_part')
                  : $r('app.media.curtain_icon_right_closed'))
                  .width('45%')
                  .height(180)
                  .objectFit(ImageFit.Cover)
              }
              .width('100%')
              .height(180)
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ left: 4, right: 4 })

              // 布帘控制按钮
              Row() {
                // 打开按钮
                Column() {
                  Column() {
                    Image($r('app.media.curtain_icon_open'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Contain)
                  }
                  .width(44)
                  .height(44)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundImage($r('app.media.curtain_btn_selected_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(10)
                  .onClick(() => {
                    this.curtainOpen = 100;
                    this.viewModel.openCurtain();
                  })

                  Text('打开')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .margin({ top: 6 })
                }

                // 暂停按钮
                Column() {
                  Column() {
                    Image($r('app.media.curtain_icon_pause'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Contain)
                  }
                  .width(44)
                  .height(44)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundImage($r('app.media.curtain_btn_unselected_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(10)
                  .onClick(() => {
                    // 暂停窗帘运动（暂无实现）
                  })

                  Text('暂停')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .margin({ top: 6 })
                }
                .margin({ left: 24, right: 24 })

                // 关闭按钮
                Column() {
                  Column() {
                    Image($r('app.media.curtain_icon_close'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Contain)
                  }
                  .width(44)
                  .height(44)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundImage($r('app.media.curtain_btn_unselected_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(10)
                  .onClick(() => {
                    this.curtainOpen = 0;
                    this.viewModel.closeCurtain();
                  })

                  Text('关闭')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .margin({ top: 6 })
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ top: 12 })
            }
            .width('90%')
            .padding(16)
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .backdropBlur(20)
            .borderRadius(16)
            .margin({ bottom: 24 })

            // 模块三：窗纱部分
            Column() {
              // 窗纱标签
              Text('窗纱')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFFFFF')
                .alignSelf(ItemAlign.Start)
                .margin({ bottom: 8 })

              // 顶部横杆
              Image($r('app.media.curtain_icon_top_bar'))
                .width('100%')
                .height(20)
                .objectFit(ImageFit.Contain)
                .margin({ bottom: 0 })

              // 窗纱状态展示
              Row() {
                // 左侧窗纱
                Image(this.screenOpen > 50
                  ? $r('app.media.curtain_icon_window_screening_left_part')
                  : $r('app.media.curtain_icon_window_screening_left_part_closed'))
                  .width('45%')
                  .height(180)
                  .objectFit(ImageFit.Cover)

                // 右侧窗纱
                Image(this.screenOpen > 50
                  ? $r('app.media.curtain_icon_window_screening_right_part')
                  : $r('app.media.curtain_icon_window_screening_right_part_closed'))
                  .width('45%')
                  .height(180)
                  .objectFit(ImageFit.Cover)
              }
              .width('100%')
              .height(180)
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ left: 4, right: 4 })

              // 窗纱控制按钮
              Row() {
                // 打开按钮
                Column() {
                  Column() {
                    Image($r('app.media.curtain_icon_open'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Contain)
                  }
                  .width(44)
                  .height(44)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundImage($r('app.media.curtain_btn_selected_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(10)
                  .onClick(() => {
                    this.screenOpen = 100;
                    this.viewModel.openScreen();
                  })

                  Text('打开')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .margin({ top: 6 })
                }

                // 暂停按钮
                Column() {
                  Column() {
                    Image($r('app.media.curtain_icon_pause'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Contain)
                  }
                  .width(44)
                  .height(44)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundImage($r('app.media.curtain_btn_unselected_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(10)
                  .onClick(() => {
                    // 暂停窗纱运动（暂无实现）
                  })

                  Text('暂停')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .margin({ top: 6 })
                }
                .margin({ left: 24, right: 24 })

                // 关闭按钮
                Column() {
                  Column() {
                    Image($r('app.media.curtain_icon_close'))
                      .width(24)
                      .height(24)
                      .objectFit(ImageFit.Contain)
                  }
                  .width(44)
                  .height(44)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundImage($r('app.media.curtain_btn_unselected_bg'))
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(10)
                  .onClick(() => {
                    this.screenOpen = 0;
                    this.viewModel.closeScreen();
                  })

                  Text('关闭')
                    .fontSize(12)
                    .fontColor('#FFFFFF')
                    .margin({ top: 6 })
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ top: 12 })
            }
            .width('90%')
            .padding(16)
            .backgroundColor('rgba(255, 255, 255, 0.1)')
            .backdropBlur(20)
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
}
