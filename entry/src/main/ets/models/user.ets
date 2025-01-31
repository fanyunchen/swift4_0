// 登录页需要的数据模型
export interface LoginForm {
  account: string
  password: string
}

export class LoginFormModel implements LoginForm {
  account: string
  password: string

  constructor(model: LoginForm) {
    this.account = model.account
    this.password = model.password
  }
}

// 封装司机信息的接口数据
export interface UserInfo {
  avatar: string // 司机头像
  name: string // 司机姓名
  number: string // 司机编号
  phone: string // 司机手机号
}

export class UserInfoModel implements UserInfo {
  avatar: string = ''
  name: string = ''
  number: string = ''
  phone: string = ''

  constructor(model: UserInfo) {
    this.avatar = model.avatar
    this.name = model.name
    this.number = model.number
    this.phone = model.phone
  }
}