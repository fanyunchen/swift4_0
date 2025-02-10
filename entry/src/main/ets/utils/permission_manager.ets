import { abilityAccessCtrl, bundleManager, common, Permissions } from "@kit.AbilityKit";

class PermissionManager {
  /**
   *  检查是否有权限
   * @param permission  Permissions[]，需要检查权限的数组
   * @returns boolean,都拥有权限返回true，有没有权限返回false
   */
  checkPermission(permission: Permissions[]) {
    const manager = abilityAccessCtrl.createAtManager()
    // 获取应用信息
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const tokenId = appInfo.appInfo.accessTokenId
    // 校验每个权限，并返回校验的类型
    const authResults = permission.map((per) => {
      return manager.checkAccessTokenSync(tokenId, per)
    })
    // 处理授权结果
    return authResults.every(status => status === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
  }

  /**
   *  申请权限
   * @param permission Permissions[]，需要申请权限的数组
   * @returns Promise<boolean> 是否都授权成功
   */
  async requestPermission(permission: Permissions[]) {
    const manager = abilityAccessCtrl.createAtManager()
    // 申请用户授权
    const result = await manager.requestPermissionsFromUser(getContext(), permission)
    // 检验用户授权结果
    const isAuth = result.authResults.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    // Promise.resolve()成功的返回
    // Promise.reject()失败的返回 await后续的代码不会执行,可被外部catch捕获
    return isAuth === true ? Promise.resolve(true) : Promise.reject(false)
  }

  /**
   * 打开系统设置管理页让用户自己去设置
   */
  openPermissionSettingsPage() {
    const appInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    const context = getContext() as common.UIAbilityContext
    context.startAbility({
      bundleName: "com.huawei.hmos.settings", //设置的包名
      abilityName: "com.huawei.hmos.settings.MainAbility",
      uri: "application_info_entry", //参数名
      parameters: {
        pushParams: appInfo.name
      }
    })
  }
}

export const permissionManager = new PermissionManager()