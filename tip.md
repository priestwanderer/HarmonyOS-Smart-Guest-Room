# 鸿蒙智慧酒店项目（HarmonyOS Smart Hotel）开发指令
## 1. 项目背景与目标  
开发一个基于 HarmonyOS NEXT 的智慧酒店客房控制系统。该应用允许用户通过手机端远程或在房内控制空调、灯光、窗帘及请求客房服务。

**核心技术栈**  
系统/SDK: HarmonyOS NEXT (Target SDK: 6.0.0, API Level 20)

开发语言: ArkTS

UI 框架: ArkUI (声明式 UI)

架构模式: MVVM

状态管理 (V2 装饰器):

@ObservedV2：用于标记可观察的类。

@Trace：用于标记类中需要响应式变化的属性。

@ComponentV2：定义 V2 版本的组件。

@Param：接收父组件传递的参数。

@Event：用于子组件向父组件发送回调。

双向绑定: 必须使用 !! 语法，严禁使用旧版本的 $$。

## 2. 目录结构规范  
请严格按照以下路径生成代码，确保模块职责分离：  

entry/src/main/ets/
├── common/                  # 公共常量、工具类
├── model/                   # 数据实体 (使用 @ObservedV2 和 @Trace)
│   └── RoomModel.ets        # 房间状态、灯光、窗帘、空调数据模型
├── view/                    # 抽离的可复用组件 (使用 @ComponentV2)
│   ├── ControlPanel.ets     # 控制面板容器
│   ├── DeviceSwitch.ets     # 设备开关组件
│   └── SceneCard.ets        # 场景模式卡片
├── viewmodel/               # 业务逻辑层
│   └── RoomViewModel.ets    # 核心状态维护与逻辑处理
└── pages/                   # 页面入口
    ├── Index.ets            # 入口/登录页
    ├── MainDashboard.ets    # 智慧客房主控页
    ├── LightControl.ets     # 灯光控制页
    ├── CurtainControl.ets   # 窗帘控制页
    └── ServiceControl.ets   # 服务控制页
## 3. 详细分层需求
- A. Model 层 (model/) (数据定义)
**RoomState.ets**
- 字段：`id`,``roomNumber` (string), `airConditioner` (object), `lights` (array), `curtains` (object), `sceneMode` (string), `services` (object)。
- 纯数据类，无业务逻辑。

创建一个 RoomState 类，涵盖以下属性（全部使用 @Trace）：

空调: 运行状态 (boolean)、当前温度 (number)、设定温度 (number)。

灯光: 总开关 (boolean)、各区域灯光列表（洗手间、衣柜、落地灯等）。

窗帘: 布帘状态 (百分比/状态)、窗纱状态。

模式: 明亮、柔和、阅读、温馨、睡眠。

服务: 请勿打扰、清理房间。

- B. ViewModel 层 (viewmodel/) (业务逻辑)

****RoomViewModel.ets**
- 使用 @ObservedV2 装饰器。
- 状态 (使用 @Trace)装饰所有属性，实现响应式
- 包装单个对象
- 管理 RoomState 实例，提供对空调、灯光、窗帘、场景模式及服务状态的控制方法。
维护一个 RoomState 实例。

提供修改状态的方法：如 updateTemperature(offset: number)、toggleLight(id: string)、switchScene(mode: string)。

逻辑需保证数据单向流动，通过方法修改 Trace 属性。

- C. View 层 (view/ & pages/) (UI 实现)

**主页面**
- 使用 @Entry 和 @ComponentV2 装饰器。
- 实例化 RoomViewModel。
- UI 包含：
  - 智慧客房主页面面板（空调开关控制、灯光控制、窗帘控制、服务控制）
  - 底部导航栏，包含：首页、灯光、窗帘、服务四个 Tab。

根据提供的设计图，UI 需体现“高端科技感”：

配色: 深色背景，配合金色/白色的高对比文字，使用磨砂玻璃（Glassmorphism）效果。

组件要求:

主页: 顶部欢迎语 + 房号；中间空调控制卡片；下方 2x2 的场景模式按钮；最下方快捷服务按钮。

灯光页: 顶层一个巨大的主开关；下方网格布局展示各独立灯位开关（使用 Toggle 组件并自定义样式）。

窗帘页: 模拟窗帘开合的视觉动画展示；提供“打开、暂停、关闭”三个控制按钮。

底部导航: 首页、灯光、窗帘、服务四个 Tab。

## 4. 关键代码实现约束（Claude 必读）
1. 状态管理 V2 示例参考：

@ObservedV2
export class LightInfo {
  @Trace isOpened: boolean = false;
  name: string = '';
}

@ComponentV2
struct DeviceSwitch {
  @Param isOpened: boolean = false;
  @Event onChange: (val: boolean) => void;

  build() {
    Toggle({ type: ToggleType.Switch, isOn: this.isOpened!! }) // 使用 !! 进行双向绑定
      .onChange((value: boolean) => {
        this.onChange(value);
      })
  }
}
2. UI 细节渲染：
使用 LinearGradient 实现背景渐变。

使用 backgroundBlurStyle 实现控制卡片的背板模糊效果。

空调温度调节按钮需支持点击交互。

SOS 按钮需使用明显的红色警示色。

5. 任务指令
现在，请按照上述架构和设计图逻辑，依次生成以下核心文件：

model/RoomModel.ets

viewmodel/RoomViewModel.ets

pages/MainDashboard.ets (主控制页)

view/ControlPanel.ets (通用控制卡片组件)

要求： 代码注释清晰，符合华为官方代码规范，确保 API 20 环境下可直接运行。