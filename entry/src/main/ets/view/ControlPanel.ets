/**
 * 通用控制面板组件
 * 磨砂玻璃效果的卡片容器
 */
@ComponentV2
export struct ControlPanel {
  @Param title: string = '';

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
        .margin({ bottom: 16 })
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN)
    .backgroundColor('rgba(0,0,0,0)')
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [
        [0x000000, 0.7],
        [0x000000, 1.0]
      ]
    })
  }
}
