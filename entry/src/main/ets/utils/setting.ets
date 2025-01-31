import preferences from "@ohos.data.preferences"
import { TOKEN_KEY, USER_SETTING, USER_SETTING_AD } from "../constants"
import { AdvertClass } from "../models"

/**
 * 默认广告
 */
const defaultAd: AdvertClass = {
  showAd: true,
  adTime: 5,
  adImg: $r('app.media.start')
}

/**
 * 首选项
 * 功能1：实现广告数据的存储
 * 功能2：实现用户信息的存储: 令牌 token
 */
export class UserSettingClass {
  context: Context

  constructor(context: Context) {
    this.context = context
  }

  /**
   * 获取首选项对象
   * @returns Promise<preferences.Preferences>
   */
  getStore() {
    return preferences.getPreferences(this.context, USER_SETTING)
  }

  /**
   * 读取广告首选项
   * @returns Promise<AdvertClass>
   */
  async getUserAd() {
    const store = await this.getStore()
    // 获取广告数据的字符串形式
    const result = await store.get(USER_SETTING_AD, JSON.stringify(defaultAd)) as string
    // 返回广告数据 对象类型
    return JSON.parse(result) as AdvertClass
  }

  /**
   * 存储广告首选项
   * @param ad  广告数据
   */
  async setUserAd(ad: AdvertClass) {
    const store = await this.getStore()
    // 写入广告数据
    await store.put(USER_SETTING_AD, JSON.stringify(ad))
    // 持久化广告数据
    await store.flush()
  }

  /**
   * 存储用户信息
   * @param token 用户令牌token
   */
  async setUserToken(token: string) {
    const store = await this.getStore()
    // 写入广告数据
    await store.put(TOKEN_KEY, JSON.stringify(token))
    // 持久化广告数据
    await store.flush()
  }

  /**
   * 获取用户信息
   */
  async getUserToken() {
    const store = await this.getStore()
    return await store.get(TOKEN_KEY, '') as string
  }
}