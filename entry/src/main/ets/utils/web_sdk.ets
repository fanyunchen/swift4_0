import { webview } from '@kit.ArkWeb'
import { geoLocationManager } from '@kit.LocationKit'

export class WebSdkClass {
  static webController: webview.WebviewController | null = null
  static Context: Context | null = null

  /**
   * 提供业务方法给页面端使用
   * @param message
   */
  alert(message: string) {
    AlertDialog.show({ message: message })
  }

  // 设置地图的中心点位置
  async setCurrentLocation() {
    try {
      // 1.获取经纬度
      const result = await geoLocationManager.getCurrentLocation()

      // 2.设置地图定位
      WebSdkClass.webController?.runJavaScript(`setLocation(${result.longitude},${result.latitude})`)
    } catch (err) {
      AlertDialog.show({ message: '获取经纬度失败:' + JSON.stringify(err) })
    }
  }

  /**
   * 获取网页端获取到的数据
   * @param json 网页端获取到的数据
   */
  receiveData(json: string) {
    // AlertDialog.show({ message: '鸿蒙端显示' + json })
    console.log('hmlog-->', 'sdk json' + json)
    WebSdkClass.Context?.eventHub.emit("search_list", json)
  }
}