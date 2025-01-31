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

// 封装本月任务接口相关数据：请求数据，响应数据:
// 请求数据
export interface UserTaskInfoParams {
  month: string
  year: string
}

export class UserTaskInfoParamsModel implements UserTaskInfoParams {
  month: string = ''
  year: string = ''

  constructor(model: UserTaskInfoParams) {
    this.month = model.month
    this.year = model.year
  }
}

export interface DailyMileage {
  dateTime: string | null // 日期 格式：2022-07-16 00:00:00
  mileage: number | null // 里程 单位：公里 计算公式：原始数据(单位米)/1000 四舍五入取整
}

export class DailyMileageModel implements DailyMileage {
  dateTime: string | null = null
  mileage: number | null = null

  constructor(model: DailyMileage) {
    this.dateTime = model.dateTime
    this.mileage = model.mileage
  }
}

// 响应数据
export interface UserTaskInfo {
  completedAmounts: number // 完成任务数量，基于实际完成时间统计
  dailyMileage: DailyMileage[] // 每日里程，基于实际完成时间统计
  taskAmounts: number // 任务数量，基于计划完成时间统计
  transportMileage: number // 运输里程，单位：公里，基于实际完成时间统计
}

export class UserTaskInfoModel implements UserTaskInfo {
  completedAmounts: number = 0
  dailyMileage: DailyMileage[] = []
  taskAmounts: number = 0
  transportMileage: number = 0

  constructor(model: UserTaskInfo) {
    this.completedAmounts = model.completedAmounts
    this.dailyMileage = model.dailyMileage
    this.taskAmounts = model.taskAmounts
    this.transportMileage = model.transportMileage
  }
}