# HarmonyOS 智慧客房

基于 HarmonyOS (OpenHarmony) 的客房控制应用，通过后端 API 实现入住登录、设备状态获取、灯光场景与空调控制。

## 功能
- 入住登录（Token 认证）
- 房间状态获取
- 灯光场景控制
- 空调控制
- 本地偏好持久化

## 技术栈
- HarmonyOS ArkTS / ETS（ComponentV2/ObservedV2）
- @ohos.net.http
- @ohos.data.preferences
- MVVM（View + ViewModel + Model）

## 目录结构
- entry/src/main/ets/Apiservice/Apiservice.ets: API 客户端与请求封装
- entry/src/main/ets/viewmodel/RoomViewModel.ets: 状态管理与业务动作
- entry/src/main/ets/pages/Index.ets: 登录页
- entry/src/main/ets/pages/MainDashboard.ets: 主页面

## API 概览
基础地址: https://ohosiot.admitpro.cn

接口（POST）:
- /api/sso/login
- /api/rcu/room/getState
- /api/rcu/room/setLightMode
- /api/rcu/room/clickAirBtn

认证方式: RCU 接口需在请求头带 `Authorization: Bearer {token}`。

## 环境要求
- DevEco Studio（建议使用 HarmonyOS/ArkTS 对应版本）
- 设备或模拟器（支持 HarmonyOS/OpenHarmony）

## 运行
1) 使用 DevEco Studio 打开项目目录 `HarmonyOS_Smart_Guest_Room`  
2) 选择设备或模拟器  
3) 运行入口模块 `entry`

## 配置与参数
- API 基础地址在 `entry/src/main/ets/Apiservice/Apiservice.ets` 的 `baseUrl` 常量
- 登录参数为 `roomNo` 与 `firstName`
- Token 与 roomNo 存储在本地 preferences（`smart_guest_room`）

## 日志与排查
- 关键请求日志在 `entry/src/main/ets/Apiservice/Apiservice.ets`（request/response）
- 登录失败常见原因：
  - 服务端返回 JWT 生成错误（如缺少 `expire_time`）
  - Token 未落库导致后续接口返回 `token为空`
- 若页面能进入但接口返回 401/1000，请确认登录成功并携带 Authorization

## 版本说明
- UI 使用 ComponentV2 + ObservedV2（ArkTS V2 语法风格）

## License
内部或项目自定义（请按需补充）。
