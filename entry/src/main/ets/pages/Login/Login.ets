import { LoginFormModel } from '../../models';
import { http } from '@kit.NetworkKit';

@Entry
@Component
struct Login {
  @State showLoading: boolean = false;
  @State accountForm:LoginFormModel = new LoginFormModel({account:'',password:''})

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
        this.showLoading = true
        // 调用服务端的后台接口完成用户身份的验证
        const loginUrl = "http://122.51.240.24:31007/driver/login/account"
        // 1.创建请求对象，注意：每次请求都需要创建一个新的，不能重复使用
        const httpRequest = http.createHttp()
        // 2.设置请求头
        const config:http.HttpRequestOptions = {
          method:http.RequestMethod.POST,
          header:{
            "Content-Type":"application/json",  // 请求数据类型
            "Authorization":''  // 令牌
          },
          extraData:this.accountForm
        }
        // 3.发送请求
        const res = await httpRequest.request(loginUrl,config)
        // 4.解析请求结果
        AlertDialog.show({message:JSON.stringify(res,null,2)})

        // 5.关闭请求对象
        httpRequest.destroy()

        this.showLoading = false
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