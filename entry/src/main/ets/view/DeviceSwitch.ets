/**
 * 设备开关组件
 * 可复用的开关控件
 */
@ComponentV2
export struct DeviceSwitch {
  @Param isOpened: boolean = false;
  @Event onChange: (val: boolean) => void = () => {};

  build() {
    Toggle({ type: ToggleType.Switch, isOn: this.isOpened })
      .selectedColor('#FFD700')
      .onChange((value: boolean) => {
        this.onChange(value);
      })
  }
}
