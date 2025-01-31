// 实现用户接口的调用
import { LoginFormModel } from '../models'
import { Request } from '../utils'

// 1.用户登录接口的调用
export const login = (data: LoginFormModel): Promise<string | null> => {
  return Request.post<string>("/login/account", data);
}