import { RoomViewModel } from '../viewmodel/RoomViewModel';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

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
      Column()
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.service_bg'))
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

          Text('服务控制')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 40, bottom: 20 })

        Scroll() {
          Column() {
            // 请勿打扰卡片
            Column() {
              Row() {
                // 图标
                Image($r('app.media.service_icon_do_not_disturb'))
                  .width(40)
                  .height(40)

                // 标题和状态
                Column() {
                  Text('请勿打扰')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#FFFFFF')

                  Text(this.viewModel.roomModel.service.doNotDisturb ? '已开启' : '已关闭')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                    .opacity(0.7)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Center)
                .margin({ left: 16 })

                Blank()

                // 开关
                Image(this.viewModel.roomModel.service.doNotDisturb
                  ? $r('app.media.service_toggle_dots_bg')
                  : $r('app.media.service_toggle_bg'))
                  .width(60)
                  .height(32)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.viewModel.toggleDoNotDisturb();
                  })
              }
              .width('100%')
              .padding(16)
            }
            .width('90%')
            .height(80)
            .backgroundImage($r('app.media.service_do_not_disturb_bg'))
            .backgroundImageSize(ImageSize.Cover)
            .borderRadius(16)
            .margin({ bottom: 20 })

            // 清理房间卡片
            Column() {
              Row() {
                // 图标
                Image($r('app.media.service_icon_clean_room'))
                  .width(40)
                  .height(40)

                // 标题和状态
                Column() {
                  Text('清理房间')
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#FFFFFF')

                  Text(this.viewModel.roomModel.service.cleanRoom ? '已请求' : '未请求')
                    .fontSize(14)
                    .fontColor('#FFFFFF')
                    .opacity(0.7)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Center)
                .margin({ left: 16 })

                Blank()

                // 开关
                Image(this.viewModel.roomModel.service.cleanRoom
                  ? $r('app.media.service_toggle_dots_bg')
                  : $r('app.media.service_toggle_bg'))
                  .width(60)
                  .height(32)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.viewModel.toggleCleanRoom();
                  })
              }
              .width('100%')
              .padding(16)
            }
            .width('90%')
            .height(80)
            .backgroundImage($r('app.media.service_clean_room_bg'))
            .backgroundImageSize(ImageSize.Cover)
            .borderRadius(16)
            .margin({ bottom: 40 })

            // SOS 紧急呼叫按钮
            Column() {
              Row() {
                Image($r('app.media.service_btn_sos_bg'))
                  .width('100%')
                  .height(140)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .height(140)
              .onClick(() => {
                // SOS 紧急呼叫功能
                promptAction.showDialog({
                  title: '紧急呼叫',
                  message: '已发送紧急呼叫请求，工作人员将尽快到达',
                  buttons: [
                    {
                      text: '确定',
                      color: '#FF3333'
                    }
                  ]
                });
              })
            }
            .width('90%')
            .height(140)
            .margin({ bottom: 40 })

            // 退房按钮
            Column() {
              Image($r('app.media.service_btn_logout'))
                .width(200)
                .height(56)
                .objectFit(ImageFit.Cover)

              Text('')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#000000')
                .position({ left: 60, top: 18 })
            }
            .width(200)
            .height(56)
            .margin({ bottom: 40 })
            .onClick(() => {
              this.viewModel.reset();
              router.replaceUrl({
                url: 'pages/Index'
              });
            })
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
            Image($r('app.media.tabs_icon_service_select'))
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
