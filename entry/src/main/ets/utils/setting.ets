import preferences from "@ohos.data.preferences"
import { USER_SETTING, USER_SETTING_AD } from "../constants"
import { AdvertClass } from "../models"

/**
 * 默认广告
 */
const defaultAd:AdvertClass = {
  showAd:true,
  adTime:5,
  adImg:$r('app.media.start')
}

/**
 * 广告首选项
 */
export class UserSettingClass {
  // 功能1：实现广告数据的存储
  context:Context

  constructor(context:Context) {
    this.context = context
  }

  // 1.获取首选项对象
  getStore(){
    return preferences.getPreferences(this.context,USER_SETTING)
  }

  // 2.读取广告首选项
  async getUserAd(){
    const store = await this.getStore()
    // 获取广告数据的字符串形式
    const result = await store.get(USER_SETTING_AD,JSON.stringify(defaultAd)) as string
    // 返回广告数据 对象类型
    return JSON.parse(result) as AdvertClass
  }

  // 3.存储广告首选项
  async setUserAd(ad:AdvertClass){
    const store = await this.getStore()
    // 写入广告数据
    await store.put(USER_SETTING_AD,JSON.stringify(ad))
    // 持久化广告数据
    await store.flush()
  }

}