import { RoomViewModel } from '../viewmodel/RoomViewModel';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import preferences from '@ohos.data.preferences';
import hilog from '@ohos.hilog';

@Entry
@ComponentV2
struct Index {
  @Local roomNumber: string = '';
  @Local firstName: string = '';
  @Local viewModel: RoomViewModel = new RoomViewModel();
  @Local rememberInfo: boolean = false; // 是否记住我的信息
  @Local isLoading: boolean = false;
  @Local isInitialized: boolean = false;

  async aboutToAppear() {
    await this.viewModel.init(getContext());
    await this.loadSavedInfo();
    this.isInitialized = true;
  }

  // 加载保存的信息
  async loadSavedInfo(): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(getContext(this), 'loginInfo');
      const savedRoomNumber: string = await prefs.get('roomNumber', '') as string;
      const savedFirstName: string = await prefs.get('firstName', '') as string;
      const savedRemember: boolean = await prefs.get('rememberInfo', false) as boolean;

      if (savedRemember && savedRoomNumber && savedFirstName) {
        this.roomNumber = savedRoomNumber;
        this.firstName = savedFirstName;
        this.rememberInfo = true;
      }
    } catch (err) {
      console.error('Failed to load saved info:', err);
    }
  }

  // 保存信息
  async saveInfo(): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(getContext(this), 'loginInfo');
      await prefs.put('roomNumber', this.roomNumber.trim());
      await prefs.put('firstName', this.firstName.trim());
      await prefs.put('rememberInfo', this.rememberInfo);
      await prefs.flush();
    } catch (err) {
      console.error('Failed to save info:', err);
    }
  }

  // 清除保存的信息
  async clearSavedInfo(): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(getContext(this), 'loginInfo');
      await prefs.delete('roomNumber');
      await prefs.delete('firstName');
      await prefs.delete('rememberInfo');
      await prefs.flush();
    } catch (err) {
      console.error('Failed to clear saved info:', err);
    }
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
        // 标题
        Text('广科·未来酒店')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .margin({ top: 60, bottom: 16 })

        // 欢迎文字
        Text('华为ICT学院专属智臻旅居体验')
          .fontSize(18)
          .fontWeight(FontWeight.Regular)
          .fontColor('#FFFFFF')
          .margin({ bottom: 40 })

        // 磨砂玻璃容器
        Column() {
          // 客房号输入
          Column() {
            Row() {
              Image($r('app.media.icon_input_room'))
                .width(24)
                .height(24)
                .margin({ right: 12 })

              TextInput({ placeholder: '请输入客房号' })
                .width(200)
                .height(44)
                .fontSize(16)
                .fontColor('#FFFFFF')
                .backgroundColor(Color.Transparent)
                .placeholderColor('#FFFFFF')
                .onChange((value: string) => {
                  this.roomNumber = value;
                })
            }
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor('rgba(255, 255, 255, 0.15)')
            .borderRadius(8)
          }
          .width(280)
          .margin({ bottom: 24 })

          // 用户名输入
          Column() {
            Row() {
              Image($r('app.media.icon_input_user'))
                .width(24)
                .height(24)
                .margin({ right: 12 })

              TextInput({ placeholder: '请输入姓名' })
                .width(200)
                .height(44)
                .fontSize(16)
                .fontColor('#FFFFFF')
                .backgroundColor(Color.Transparent)
                .placeholderColor('#FFFFFF')
                .onChange((value: string) => {
                  this.firstName = value;
                })
            }
            .width('100%')
            .height(44)
            .padding({ left: 12, right: 12 })
            .backgroundColor('rgba(255, 255, 255, 0.15)')
            .borderRadius(8)
          }
          .width(280)
          .margin({ bottom: 24 })

          // 选项行
          Row() {
            // 记住我的信息
            Row() {
              Toggle({
                type: ToggleType.Checkbox,
                isOn: this.rememberInfo
              })
                .width(20)
                .height(20)
                .onChange((isOn: boolean) => {
                  this.rememberInfo = isOn;
                })

              Text('记住我的信息')
                .fontSize(14)
                .fontColor('#FFFFFF')
                .margin({ left: 8 })
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 16 })

          // 跳过登录（测试用）- 后端修复后请删除此选项
          Text('[跳过登录]')
            .fontSize(12)
            .fontColor('rgba(255,255,255,0.6)')
            .decoration({ type: TextDecorationType.Underline })
            .onClick(() => {
              // 跳过登录，直接跳转
              router.pushUrl({
                url: 'pages/MainDashboard'
              }).catch((err: Error) => {
                hilog.error(0x0, 'Index', `Navigation failed: ${err.message}`);
              });
            })
            .margin({ bottom: 16 })

          // 登录按钮
          Button(this.isLoading ? '登录中...' : '立即入住')
            .width(200)
            .height(48)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#000000')
            .backgroundColor(Color.White)
            .borderRadius(24)
            .enabled(this.roomNumber.trim().length >= 3 && this.firstName.trim().length > 0 && this.isInitialized && !this.isLoading)
            .onClick(async () => {
              hilog.info(0x0, 'Index', 'login button clicked');
              if (this.roomNumber.trim().length >= 3 && this.firstName.trim().length > 0 && this.isInitialized) {
                hilog.info(0x0, 'Index', `login with roomNumber: ${this.roomNumber.trim()}, firstName: ${this.firstName.trim()}`);
                this.isLoading = true;
                // 如果记住信息，先保存
                if (this.rememberInfo) {
                  await this.saveInfo();
                }

                try {
                  const ok = await this.viewModel.login(this.roomNumber.trim(), this.firstName.trim());
                  hilog.info(0x0, 'Index', `login result: ${ok}`);
                  this.isLoading = false;
                  if (!ok) {
                    hilog.info(0x0, 'Index', 'login failed, showing dialog');
                    promptAction.showDialog({
                      title: '登录失败',
                      message: '请检查房号和姓名',
                      buttons: [
                        {
                          text: '确定',
                          color: '#000000'
                        }
                      ]
                    });
                    return;
                  }
                  // 登录成功，直接跳转
                  hilog.info(0x0, 'Index', 'login success, navigating to MainDashboard');
                  router.pushUrl({
                    url: 'pages/MainDashboard',
                    params: {
                      roomNumber: this.roomNumber.trim()
                    }
                  }).catch((err: Error) => {
                    hilog.error(0x0, 'Index', `Navigation failed: ${err.message}`);
                  });
                } catch (err) {
                  hilog.error(0x0, 'Index', `login exception: ${String(err)}`);
                  this.isLoading = false;
                  promptAction.showDialog({
                    title: '登录失败',
                    message: '网络请求失败，请检查网络连接',
                    buttons: [
                      {
                        text: '确定',
                        color: '#000000'
                      }
                    ]
                  });
                }
              } else {
                hilog.info(0x0, 'Index', 'input validation failed or not initialized');
              }
            })
        }
        .width(320)
        .padding(24)
        .backgroundColor('rgba(0, 0, 0, 0.3)')
        .backdropBlur(20)
        .borderRadius(24)
        .margin({ bottom: 40 })
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
