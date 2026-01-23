import type Context from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import { ApiService, AirState, RoomStateResponse, RoomStateData, LightModeHardware } from '../Apiservice/Apiservice';
import { RoomModel, LightState } from '../model/RoomModel';

class LightModeIds {
  bright?: number;
  soft?: number;
  read?: number;
  warm?: number;
  sleep?: number;
}

@ObservedV2
export class RoomViewModel {
  @Trace roomModel: RoomModel = new RoomModel();
  private api: ApiService = ApiService.getInstance();
  private airDeviceId: number = 0;
  private lightModeIds: LightModeIds = new LightModeIds();
  private temperatureTimer?: number;
  private useBackendValidation: boolean = true; // 控制是否使用后端校验

  async init(context: Context): Promise<void> {
    await this.api.init(context);
    const storedRoomNo = this.api.getRoomNo();
    if (storedRoomNo && !this.roomModel.roomNumber) {
      this.roomModel.roomNumber = storedRoomNo;
    }
  }

  async login(roomNo: string, firstName: string): Promise<boolean> {
    try {
      if (this.useBackendValidation) {
        // 使用后端校验
        await this.api.login(roomNo, firstName);
      }
      this.roomModel.roomNumber = roomNo;
      return true;
    } catch (err) {
      hilog.error(0x0, 'RoomViewModel', `login failed: ${String(err)}`);
      return false;
    }
  }

  setUseBackendValidation(useBackend: boolean): void {
    this.useBackendValidation = useBackend;
  }

  async loadRoomState(roomNo?: string): Promise<void> {
    try {
      const data = await this.api.getRoomState(roomNo || this.roomModel.roomNumber);
      this.applyRoomState(data);
    } catch (err) {
      hilog.error(0x0, 'RoomViewModel', `getState failed: ${String(err)}`);
    }
  }

  setRoomNumber(roomNumber: string): void {
    this.roomModel.roomNumber = roomNumber;
    void this.api.setRoomNo(roomNumber);
  }

  toggleAirConditioner(): void {
    this.roomModel.airConditioner.isRunning = !this.roomModel.airConditioner.isRunning;
    if (this.airDeviceId && this.roomModel.roomNumber) {
      const value = this.roomModel.airConditioner.isRunning ? 1 : 0;
      void this.api.clickAirBtn(this.roomModel.roomNumber, this.airDeviceId, 'power', value)
        .catch((err: Error) => {
          hilog.error(0x0, 'RoomViewModel', `air power failed: ${String(err)}`);
        });
    }
  }

  updateTemperature(offset: number): void {
    const newTemp = this.roomModel.airConditioner.targetTemperature + offset;
    if (newTemp < 16 || newTemp > 30) {
      return;
    }
    this.roomModel.airConditioner.targetTemperature = newTemp;
    if (!this.airDeviceId || !this.roomModel.roomNumber) {
      return;
    }
    if (this.temperatureTimer) {
      clearTimeout(this.temperatureTimer);
    }
    this.temperatureTimer = setTimeout(() => {
      void this.api.clickAirBtn(this.roomModel.roomNumber, this.airDeviceId, 'temp', newTemp)
        .catch((err: Error) => {
          hilog.error(0x0, 'RoomViewModel', `air temp failed: ${String(err)}`);
        });
    }, 350);
  }

  toggleLight(id: string): void {
    const light = this.roomModel.lights.find(item => item.id === id);
    if (light) {
      light.isOpened = !light.isOpened;
    }
  }

  setLightState(id: string, isOpened: boolean): void {
    const light = this.roomModel.lights.find(item => item.id === id);
    if (light) {
      light.isOpened = isOpened;
    }
  }

  toggleAllLights(isOpen: boolean): void {
    this.roomModel.lights.forEach(light => {
      light.isOpened = isOpen;
    });
  }

  switchScene(mode: string): void {
    this.roomModel.sceneMode = mode;
    const hardwareId = this.getLightModeId(mode);
    if (hardwareId && this.roomModel.roomNumber) {
      void this.api.setLightMode(this.roomModel.roomNumber, hardwareId)
        .catch((err: Error) => {
          hilog.error(0x0, 'RoomViewModel', `setLightMode failed: ${String(err)}`);
        });
    }
    switch (mode) {
      case 'bright':
        this.toggleAllLights(true);
        this.roomModel.airConditioner.targetTemperature = 26;
        break;
      case 'soft':
        this.toggleAllLights(false);
        break;
      case 'read':
        this.toggleAllLights(false);
        break;
      case 'warm':
        this.toggleAllLights(true);
        break;
      case 'sleep':
        this.toggleAllLights(false);
        break;
    }
  }

  setCurtainState(percentage: number): void {
    this.roomModel.curtain.curtainOpen = Math.max(0, Math.min(100, percentage));
  }

  setScreenState(percentage: number): void {
    this.roomModel.curtain.screenOpen = Math.max(0, Math.min(100, percentage));
  }

  openCurtain(): void {
    this.roomModel.curtain.curtainOpen = 100;
  }

  closeCurtain(): void {
    this.roomModel.curtain.curtainOpen = 0;
  }

  toggleDoNotDisturb(): void {
    this.roomModel.service.doNotDisturb = !this.roomModel.service.doNotDisturb;
    if (this.roomModel.service.doNotDisturb) {
      this.roomModel.service.cleanRoom = false;
    }
  }

  toggleCleanRoom(): void {
    this.roomModel.service.cleanRoom = !this.roomModel.service.cleanRoom;
    if (this.roomModel.service.cleanRoom) {
      this.roomModel.service.doNotDisturb = false;
    }
  }

  setScreenOpen(openPercentage: number): void {
    this.roomModel.curtain.screenOpen = Math.max(0, Math.min(100, openPercentage));
  }

  openScreen(): void {
    this.setScreenOpen(100);
  }

  closeScreen(): void {
    this.setScreenOpen(0);
  }

  reset(): void {
    this.roomModel.airConditioner.isRunning = false;
    this.roomModel.airConditioner.targetTemperature = 26;
    this.roomModel.curtain.curtainOpen = 0;
    this.roomModel.curtain.screenOpen = 0;
    this.roomModel.sceneMode = '';
    this.roomModel.service.doNotDisturb = false;
    this.roomModel.service.cleanRoom = false;
    this.toggleAllLights(false);
    void this.api.clearSession();
  }

  private applyRoomState(data: RoomStateResponse): void {
    if (data.room_number) {
      this.roomModel.roomNumber = data.room_number;
    }
    const hardware = data.hardware;
    const state: RoomStateData | undefined = data.state;

    const airHardware = hardware?.airs?.[0];
    if (airHardware) {
      this.airDeviceId = airHardware.id;
      const airState = this.getAirStateByCode(state, airHardware.code);
      if (airState) {
        this.roomModel.airConditioner.isRunning = String(airState.open) === '1';
        this.roomModel.airConditioner.currentTemperature = Number(airState.currentTemp);
        this.roomModel.airConditioner.targetTemperature = Number(airState.settingTemp);
      }
    }

    const lightModes = hardware?.lightModes || [];
    this.lightModeIds = this.mapLightModeIds(lightModes);

    const lights = hardware?.lights || [];
    if (lights.length === 0) {
      // 默认灯光列表
      this.roomModel.lights = [
        { id: '1', name: '洗漱间', isOpened: false } as LightState,
        { id: '2', name: '衣柜灯', isOpened: false } as LightState,
        { id: '3', name: '落地灯', isOpened: false } as LightState,
        { id: '4', name: '吧灯', isOpened: false } as LightState,
        { id: '5', name: '书桌灯', isOpened: false } as LightState,
        { id: '6', name: '左阅读灯', isOpened: false } as LightState,
        { id: '7', name: '右阅读灯', isOpened: false } as LightState,
        { id: '8', name: '排风扇', isOpened: false } as LightState,
        { id: '9', name: '廊灯', isOpened: false } as LightState,
      ];
    } else {
      this.roomModel.lights = lights.map(lightItem => {
        const light = new LightState();
        light.id = String(lightItem.id);
        light.name = lightItem.name;
        light.isOpened = false;
        return light;
      });
    }

    if (state) {
      const clean = state.qingli;
      const disturb = state.wurao;
      this.roomModel.service.cleanRoom = String(clean) === '1';
      this.roomModel.service.doNotDisturb = String(disturb) === '1';
    }
  }

  private mapLightModeIds(
    lightModes: LightModeHardware[]
  ): LightModeIds {
    const mapping = new LightModeIds();
    lightModes.forEach(mode => {
      if (mode.cpadd === '1') {
        mapping.bright = mode.id;
      } else if (mode.cpadd === '2') {
        mapping.soft = mode.id;
      } else if (mode.cpadd === '3') {
        mapping.read = mode.id;
      } else if (mode.cpadd === '4') {
        mapping.warm = mode.id;
      } else if (mode.cpadd === 'C') {
        mapping.sleep = mode.id;
      }
    });
    return mapping;
  }

  private getLightModeId(mode: string): number | undefined {
    switch (mode) {
      case 'bright':
        return this.lightModeIds.bright;
      case 'soft':
        return this.lightModeIds.soft;
      case 'read':
        return this.lightModeIds.read;
      case 'warm':
        return this.lightModeIds.warm;
      case 'sleep':
        return this.lightModeIds.sleep;
      default:
        return undefined;
    }
  }

  private getAirStateByCode(state: RoomStateData | undefined, code: string): AirState | undefined {
    if (!state) {
      return undefined;
    }
    if (code === 'kt1') {
      return state.kt1;
    }
    if (code === 'kt2') {
      return state.kt2;
    }
    if (code === 'kt3') {
      return state.kt3;
    }
    if (code === 'kt4') {
      return state.kt4;
    }
    return undefined;
  }
}
