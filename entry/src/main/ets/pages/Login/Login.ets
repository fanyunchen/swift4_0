import { login } from '../../api';
import { TOKEN_KEY } from '../../constants';
import { LoginFormModel } from '../../models';
import { UserSettingClass } from '../../utils';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Login {
  @State showLoading: boolean = false;
  @State accountForm:LoginFormModel = new LoginFormModel({account:'',password:''})

  async login() {
    try {
      this.showLoading = true
      const token = await login(this.accountForm)

      if (token !== '' && token !== null) {
        console.log("hmlog-->",token)
        AppStorage.set(TOKEN_KEY,token)
        new UserSettingClass(getContext()).setUserToken(token)
        router.replaceUrl({url:'pages/Index/Index'})
      }
      this.showLoading = false
    } catch (err) {
      promptAction.showToast({message:JSON.stringify(err)})
      console.error("hmlog-->","login Failed.Err:" + JSON.stringify(err))
      this.showLoading = false
    }
  }

  build() {
    Column() {
      // 标题
      Text('顺风速达')
        .fontColor($r('app.color.text_primary'))
        .fontSize(18)
        .height(25)

      Row() {
        Text('账号登录')
          .fontColor($r('app.color.text_primary'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Row() {
          Text('账号登录')
            .fontColor($r('app.color.primary'))
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.ic_angle'))
            .width(10)
            .aspectRatio(1)
            .margin({ left: 5 })
        }
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      TextInput({ placeholder: '请输入账号' })
        .inputStyles()
        .onChange((value)=>{
          this.accountForm.account = value
        })

      TextInput({ placeholder: '请输入密码' })
        .inputStyles()
        .type(InputType.Password)
        .onChange((value)=>{
          this.accountForm.password = value
        })
        .onSubmit(()=>{
          // 回车登录
          if (this.accountForm.account!=='' && this.accountForm.password !== '') {
            this.login()
          }
        })

      Button() {
        Row() {
          if (this.showLoading) {
            LoadingProgress()
              .width(30)
              .height(30)
              .color($r('app.color.white'))
              .margin({ right: 12 })
          }
          Text('登录')
            .fontColor($r('app.color.white'))
        }
      }
      .width("100%")
      .height(45)
      .enabled(this.accountForm.account!=='' && this.accountForm.password !== '')
      .margin({ top: 50 })
      .backgroundColor($r('app.color.primary'))
      .onClick(async ()=>{
        this.login()
      })
    }
    .height('100%')
    .width('100%')
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }

  @Styles
  inputStyles(){
    .backgroundColor(Color.White)
    .border({
      width: {
        bottom: 1
      },
      color: $r('app.color.background_divider')
    })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }
}