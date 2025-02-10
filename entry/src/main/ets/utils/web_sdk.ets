import { webview } from '@kit.ArkWeb'

export class WebSdkClass {
  static webController: webview.WebviewController | null = null

  /**
   * 提供业务方法给页面端使用
   * @param message
   */
  alert(message: string) {
    AlertDialog.show({ message: message })
  }
}