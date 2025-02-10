import { HMCard, HMCardItem, HMNavBar } from '../../components';
import { APP_TOP_HEIGHT } from '../../constants';
import { geoLocationManager } from '@kit.LocationKit';
import { Permissions } from '@kit.AbilityKit';
import promptAction from '@ohos.promptAction';
import { permissionManager, WebSdkClass } from '../../utils';
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct SelectLocation {
  permission: Permissions[] = ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"]
  webSdk: WebSdkClass = new WebSdkClass()

  aboutToAppear(): void {
    this.checkPermission()
    WebSdkClass.webController = new webview.WebviewController()
  }

  /**
   * 获取当前位置
   */
  async getLocation() {
    try {
      let location = await geoLocationManager.getCurrentLocation()
      // AlertDialog.show({ message: JSON.stringify(location) })
    } catch (err) {
      // AlertDialog.show({ message: JSON.stringify(err) })
      if (err.code === 3301100) {
        // promptAction.showToast({ message: '请先打开位置' })
        AlertDialog.show({ message: "请先打开位置" })
      }
    }
  }

  // /**
  //  * 检查用户权限
  //  */
  // async checkPermission() {
  //   // 没有权限，需要去向用户申请权限，有的话直接获取位置
  //   // 1.获取用户权限，看用户授权过什么权限
  //   const manager = abilityAccessCtrl.createAtManager()
  //   // 获取应用信息
  //   const appInfo =
  //     bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
  //   // 2.判断是否拥有
  //   const status = manager.checkAccessTokenSync(appInfo.appInfo.accessTokenId, "ohos.permission.LOCATION")
  //   if (status === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
  //     // 未授权：需要拉取授权窗口、提示用户授权
  //     const result = await manager.requestPermissionsFromUser(getContext(),
  //       ["ohos.permission.LOCATION", "ohos.permission.APPROXIMATELY_LOCATION"])
  //     if (result.authResults[0] !== 0) {
  //       // 用户不同意：跳转到一个能设置权限的应用中
  //       const context = getContext() as common.UIAbilityContext
  //       context.startAbility({
  //         bundleName: "com.huawei.hmos.settings", //设置的包名
  //         abilityName: "com.huawei.hmos.settings.MainAbility",
  //         uri: "application_info_entry", //参数名
  //         parameters: {
  //           pushParams: appInfo.name
  //         }
  //       })
  //     } else {
  //       // 用户同意
  //       this.getLocation()
  //     }
  //   } else {
  //     // 已授权
  //     this.getLocation()
  //   }
  // }

  /**
   * 检查用户权限
   */
  async checkPermission() {
    try {
      // 检验是否权限都授权
      const bol = permissionManager.checkPermission(this.permission)
      if (bol) {
        // 都授权
        this.getLocation()
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
      HMNavBar({ title: "当前位置" })
      Web({
        src: $rawfile("location.html"),
        controller: WebSdkClass.webController
      })
        .width("100%")
        .layoutWeight(1)
        .javaScriptProxy({
          name: 'swift',
          object: this.webSdk,
          methodList: ['alert'],
          controller: WebSdkClass.webController
        })
      Column() {
        HMCard() {
          HMCardItem({ leftText: "上海滩", rightText: '100m以内' })
          HMCardItem({ leftText: "金色大厅", rightText: '100m以内' })
          HMCardItem({ leftText: "维也纳", rightText: '100m以内' })
          HMCardItem({ leftText: "中山公园", rightText: '100m以内' })
        }
      }
      .position({ y: '100%' })
      .translate({ y: -300 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}