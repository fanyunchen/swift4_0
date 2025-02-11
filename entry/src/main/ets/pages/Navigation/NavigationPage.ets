import router from '@ohos.router';
import { CommonRouterParams } from '../../models';
import { APP_TOP_HEIGHT } from '../../constants';
import { HMNavBar } from '../../components';
import { permissionManager, WebSdkClass } from '../../utils';
import { webview } from '@kit.ArkWeb';
import { Permissions } from '@kit.AbilityKit';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct NavigationPage {
  @State message: string = 'Hello World';
  permission: Permissions[] = ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"]
  start: string = ''
  end: string = ''

  aboutToAppear(): void {
    WebSdkClass.webController = new webview.WebviewController()
    WebSdkClass.Context = getContext()

    const params = router.getParams() as CommonRouterParams
    if (params && params.start && params.end) {
      this.start = params.start
      this.end = params.end
    }

    console.log('hmlog-->', 'start:' + this.start + ", end:" + this.end)

    this.checkPermission()
  }

  aboutToDisappear(): void {
    WebSdkClass.Context = null
    WebSdkClass.webController = null
  }

  /**
   * 检查用户权限
   */
  async checkPermission() {
    try {
      // 检验是否权限都授权
      const bol = permissionManager.checkPermission(this.permission)
      if (bol) {
        // 都授权
        // this.getLocation()
      } else {
        // 未授权
        await permissionManager.requestPermission(this.permission)
      }
    } catch (err) {
      promptAction.showDialog({
        alignment: DialogAlignment.Center,
        title: '权限提醒',
        message: '定位功能需要获取权限，请在设置中打开定位权限',
        buttons: [
          { text: "取消", color: $r('app.color.primary_disabled') },
          { text: "立即开启", color: $r('app.color.primary') }
        ]
      }).then((res) => {
        // 点击立即开启按钮
        if (res.index === 1) {
          // 跳转到设置让用户自己打开权限
          permissionManager.openPermissionSettingsPage()
        }
      })
    }
  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))
      HMNavBar({ title: '导航' })

      Web({
        src: $rawfile('navigation.html'),
        controller: WebSdkClass.webController
      })
        .width('100%')
        .height('100%')
        .onPageEnd(() => {
          WebSdkClass.webController?.runJavaScript(`beginDriving('${this.start}','${this.end}')`)
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}