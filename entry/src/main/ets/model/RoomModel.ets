/**
 * 空调状态数据模型
 */
@ObservedV2
export class AirConditionerState {
  @Trace isRunning: boolean = false;
  @Trace currentTemperature: number = 24;
  @Trace targetTemperature: number = 26;
}

/**
 * 单个灯光状态数据模型
 */
@ObservedV2
export class LightState {
  @Trace isOpened: boolean = false;
  id: string = '';
  name: string = '';
  icon: string = '';
}

/**
 * 窗帘状态数据模型
 */
@ObservedV2
export class CurtainState {
  @Trace curtainOpen: number = 0; // 0-100, 百分比
  @Trace screenOpen: number = 0; // 窗纱状态, 0-100
}

/**
 * 服务状态数据模型
 */
@ObservedV2
export class ServiceState {
  @Trace doNotDisturb: boolean = false;
  @Trace cleanRoom: boolean = false;
}

/**
 * 房间状态数据模型
 */
@ObservedV2
export class RoomModel {
  id: string = '';
  roomNumber: string = '';
  @Trace airConditioner: AirConditionerState = new AirConditionerState();
  @Trace lights: LightState[] = [];
  @Trace curtain: CurtainState = new CurtainState();
  @Trace sceneMode: string = ''; // bright, soft, read, warm, sleep
  @Trace service: ServiceState = new ServiceState();
}
