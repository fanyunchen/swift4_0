// 实现用户接口的调用
import { LoginFormModel, UserInfoModel } from '../models'
import { Request } from '../utils'

// 1.用户登录接口的调用
export const login = (data: LoginFormModel): Promise<string | null> => {
  return Request.post<string>("/login/account", data);
}

// 2.获取用户信息
export const getUserInfo = () => {
  return Request.get<UserInfoModel>("/users")
}