import { RoomViewModel } from '../viewmodel/RoomViewModel';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@ComponentV2
struct Index {
  @Local roomNumber: string = '';
  @Local firstName: string = '';
  @Local viewModel: RoomViewModel = new RoomViewModel();
  @Local useBackendValidation: boolean = true; // 控制是否使用后端校验

  async aboutToAppear() {
    await this.viewModel.init(getContext());
  }

  build() {
    Stack() {
      // 背景
      Image($r('app.media.bg_hotel_full'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 内容区域
      Column() {
        // Logo或标题
        Image($r('app.media.home_text_smart_guest_room'))
          .width(200)
          .height(60)
          .margin({ top: 60, bottom: 80 })
          .objectFit(ImageFit.Contain)

        // 欢迎文字
        Text('欢迎体验智慧酒店')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .margin({ bottom: 60 })

        // ????
        Column() {
          Row() {
            Image($r('app.media.icon_input_room'))
              .width(24)
              .height(24)
              .margin({ right: 12 })

            TextInput({ placeholder: '?????' })
              .width(250)
              .height(48)
              .fontSize(16)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .onChange((value: string) => {
                this.roomNumber = value;
              })
          }
          .width('100%')
          .height(48)
          .padding({ left: 16, right: 16 })
          .borderRadius(8)
          .backgroundColor(Color.White)
        }
        .margin({ bottom: 40 })

        // User name input
        Column() {
          Row() {
            Image($r('app.media.icon_input_room'))
              .width(24)
              .height(24)
              .margin({ right: 12 })

            TextInput({ placeholder: '\u8bf7\u8f93\u5165\u59d3\u540d' })
              .width(250)
              .height(48)
              .fontSize(16)
              .backgroundColor(Color.White)
              .borderRadius(8)
              .onChange((value: string) => {
                this.firstName = value;
              })
          }
          .width('100%')
          .height(48)
          .padding({ left: 16, right: 16 })
          .borderRadius(8)
          .backgroundColor(Color.White)
        }
        .margin({ bottom: 40 })

        // 后端校验开关
        Row() {
          Text('后端校验')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .margin({ right: 16 })

          Toggle({
            type: ToggleType.Checkbox,
            isOn: this.useBackendValidation
          })
            .width(40)
            .height(24)
            .onChange((isOn: boolean) => {
              this.useBackendValidation = isOn;
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 20 })

        // 登录按钮
        Button('进入客房')
          .width(200)
          .height(48)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#000000')
          .backgroundColor(Color.White)
          .borderRadius(24)
          .enabled(this.roomNumber.trim().length >= 3 && this.firstName.trim().length > 0)
          .onClick(async () => {
            if (this.roomNumber.trim().length >= 3 && this.firstName.trim().length > 0) {
              this.viewModel.setRoomNumber(this.roomNumber.trim());
              this.viewModel.setUseBackendValidation(this.useBackendValidation);
              const ok = await this.viewModel.login(this.roomNumber.trim(), this.firstName.trim());
              if (!ok) {
                promptAction.showDialog({
                  title: '登录失败',
                  message: '请检查房号和姓名',
                  buttons: [
                    {
                      text: '确定',
                      color: '#000000'
                    }
                  ]
                }).catch((err?: Error) => {
                  if (err) {
                    console.error('Dialog failed:', err.message);
                  }
                });
                return;
              }
              // Navigate to main dashboard
              router.pushUrl({
                url: 'pages/MainDashboard',
                params: {
                  roomNumber: this.roomNumber.trim()
                }
              });
            }
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [
        [0x000000, 0.0],
        [0x000000, 1.0]
      ]
    })
  }
}
