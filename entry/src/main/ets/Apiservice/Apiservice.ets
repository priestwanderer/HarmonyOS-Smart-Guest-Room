import http from '@ohos.net.http';
import preferences from '@ohos.data.preferences';
import hilog from '@ohos.hilog';
import type Context from '@ohos.app.ability.common';

interface ApiResponse<T> {
  code: number;
  msg: string;
  data: T;
  success?: boolean;
}

export interface AirState {
  mode: number;
  settingTemp: number;
  currentTemp: number;
  open: number;
  speed: number;
}

export interface RoomStateData {
  qingli?: string;
  wurao?: string;
  kt1?: AirState;
  kt2?: AirState;
  kt3?: AirState;
  kt4?: AirState;
}

export interface AirHardware {
  code: string;
  id: number;
  name?: string;
}

export interface LightModeHardware {
  cpadd?: string;
  id: number;
  name?: string;
}

export interface LightHardware {
  id: number;
  name: string;
}

export interface RoomHardware {
  airs?: AirHardware[];
  lightModes?: LightModeHardware[];
  lights?: LightHardware[];
}

export interface RoomStateResponse {
  room_number?: string;
  state?: RoomStateData;
  hardware?: RoomHardware;
}

interface LoginRequest {
  roomNo: string;
  firstName: string;
}

interface RoomStateRequest {
  roomNo: string;
}

interface LightModeRequest {
  roomNo: string;
  hardwareId: number;
}

interface AirBtnRequest {
  roomNo: string;
  airId: number;
  cmd: string;
  value: number;
}

type RequestPayload = LoginRequest | RoomStateRequest | LightModeRequest | AirBtnRequest;

interface HttpHeaders {
  'Content-Type': string;
  Authorization?: string;
}

export class ApiService {
  private static instance: ApiService;
  private httpClient: http.HttpRequest = http.createHttp();
  private prefs?: preferences.Preferences;
  private token: string = '';
  private roomNo: string = '';
  private readonly baseUrl: string = 'https://ohosiot.admitpro.cn';

  private constructor() {}

  static getInstance(): ApiService {
    if (!ApiService.instance) {
      ApiService.instance = new ApiService();
    }
    return ApiService.instance;
  }

  async init(context: Context): Promise<void> {
    if (this.prefs) {
      return;
    }
    try {
      this.prefs = await preferences.getPreferences(context, 'smart_guest_room');
      this.token = (await this.prefs.get('token', '')) as string;
      this.roomNo = (await this.prefs.get('roomNo', '')) as string;
    } catch (err) {
      hilog.error(0x0, 'ApiService', `init failed: ${String(err)}`);
    }
  }

  getRoomNo(): string {
    return this.roomNo;
  }

  getToken(): string {
    return this.token;
  }

  async setRoomNo(roomNo: string): Promise<void> {
    this.roomNo = roomNo;
    if (this.prefs) {
      try {
        await this.prefs.put('roomNo', roomNo);
        await this.prefs.flush();
      } catch (err) {
        hilog.error(0x0, 'ApiService', `setRoomNo failed: ${String(err)}`);
      }
    }
  }

  async setToken(token: string): Promise<void> {
    this.token = token;
    if (this.prefs) {
      try {
        await this.prefs.put('token', token);
        await this.prefs.flush();
      } catch (err) {
        hilog.error(0x0, 'ApiService', `setToken failed: ${String(err)}`);
      }
    }
  }

  async clearSession(): Promise<void> {
    this.token = '';
    this.roomNo = '';
    if (this.prefs) {
      try {
        await this.prefs.put('token', '');
        await this.prefs.put('roomNo', '');
        await this.prefs.flush();
      } catch (err) {
        hilog.error(0x0, 'ApiService', `clearSession failed: ${String(err)}`);
      }
    }
  }

  async login(roomNo: string, firstName: string): Promise<string> {
    hilog.info(0x0, 'ApiService', `login request: roomNo=${roomNo}, firstName=${firstName}`);
    const payload: LoginRequest = {
      roomNo,
      firstName
    };
    // 根据接口文档，data 直接返回 token 字符串
    const token = await this.request<string>('/api/sso/login', payload, false);
    hilog.info(0x0, 'ApiService', `login success, token=${token ? token.substring(0, 20) + '...' : 'empty'}`);
    await this.setRoomNo(roomNo);
    await this.setToken(token);
    return token;
  }

  async getRoomState(roomNo?: string): Promise<RoomStateResponse> {
    const payload: RoomStateRequest = {
      roomNo: roomNo || this.roomNo
    };
    return await this.request<RoomStateResponse>('/api/rcu/room/getState', payload, true);
  }

  async setLightMode(roomNo: string, hardwareId: number): Promise<void> {
    const payload: LightModeRequest = {
      roomNo,
      hardwareId
    };
    await this.request<string>('/api/rcu/room/setLightMode', payload, true);
  }

  async clickAirBtn(roomNo: string, airId: number, cmd: string, value: number): Promise<void> {
    const payload: AirBtnRequest = {
      roomNo,
      airId,
      cmd,
      value
    };
    await this.request<string>('/api/rcu/room/clickAirBtn', payload, true);
  }

  private async request<T>(
    path: string,
    payload: RequestPayload,
    needAuth: boolean
  ): Promise<T> {
    try {
      const url = `${this.baseUrl}${path}`;
      const headers: HttpHeaders = {
        'Content-Type': 'application/json'
      };
      if (needAuth && this.token) {
        headers.Authorization = `Bearer ${this.token}`;
      }
      const authInfo = headers.Authorization ? `Bearer ***${this.token.length}` : 'none';
      hilog.info(0x0, 'ApiService', `request start: path=${path}, needAuth=${needAuth}, auth=${authInfo}`);
      hilog.info(0x0, 'ApiService', `request payload: ${JSON.stringify(payload)}`);

      const options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: headers,
        extraData: JSON.stringify(payload),
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 10000,
        readTimeout: 10000,
        usingCache: false
      };

      const response: http.HttpResponse = await this.httpClient.request(url, options);
      hilog.info(0x0, 'ApiService', `responseCode: ${response.responseCode}`);

      let body: ApiResponse<T>;
      const result = response.result as object | string;
      hilog.info(0x0, 'ApiService', `result type: ${typeof result}, result: ${JSON.stringify(result).substring(0, 300)}`);

      if (typeof result === 'string') {
        try {
          body = JSON.parse(result || '{}') as ApiResponse<T>;
        } catch (err) {
          hilog.error(0x0, 'ApiService', `JSON parse failed: ${result}`);
          throw new Error(`Invalid response: ${String(err)}`);
        }
      } else {
        body = result as ApiResponse<T>;
      }
      if (response.responseCode >= 400) {
        throw new Error(`HTTP ${response.responseCode}`);
      }

      // 登录接口：直接返回 data 中的 token 字符串
      if (path === '/api/sso/login' && body.code === 0) {
        const tokenData = body.data;
        if (typeof tokenData === 'string' && tokenData.length > 0) {
          hilog.info(0x0, 'ApiService', `login success, token length: ${tokenData.length}`);
          return tokenData as T;
        }
      }

      if (body.code !== 0) {
        hilog.error(0x0, 'ApiService', `api error: code=${body.code}, msg=${body.msg}`);
        throw new Error(body.msg || 'api error');
      }
      hilog.info(0x0, 'ApiService', `request success`);
      return body.data;
    } catch (err) {
      hilog.error(0x0, 'ApiService', `request failed: ${String(err)}`);
      const error = err instanceof Error ? err : new Error(String(err));
      throw error;
    }
  }
}
