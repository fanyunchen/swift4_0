import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AdvertClass } from '../models';
import { UserSettingClass } from '../utils';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 判断是否加载广告
    // // 1.从后台服务中获取广告数据
    // const result = await new Promise<AdvertClass>((resolve,reject)=>{
    //   setTimeout(()=>{
    //     resolve({
    //       showAd:true,
    //       adTime:10,
    //       adImg:$r('app.media.start')
    //     } as AdvertClass)
    //   },500)
    // })
    //
    // // 2.存储首选项
    // const userSetting = new UserSettingClass(this.context)
    // userSetting.setUserAd(result)

    const userSetting = new UserSettingClass(this.context)
    const result = await userSetting.getUserAd()

    // 3.判断是否需要展示广告
    if (result.showAd){
      windowStage.loadContent("pages/Start/Start")
    }else {
      // 获取用户令牌
      const token = await userSetting.getUserToken()
      if (token === ''){
        // 用户未登录
        windowStage.loadContent("pages/Login/Login")
      }else {
        // 用户已登录
        windowStage.loadContent('pages/Index', (err) => {
          if (err.code) {
            hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
            return;
          }
          hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
        });
      }
    }
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}