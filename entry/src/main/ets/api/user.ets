// 实现用户接口的调用
import { LoginFormModel, UserInfoModel, UserTaskInfoModel, UserTaskInfoParamsModel } from '../models'
import { Request, RequestAxios } from '../utils'
import { ValueType } from '@kit.ArkData';

// 1.用户登录接口的调用
export const login = (data: LoginFormModel): Promise<Record<string, ValueType> | ''> => {
  // return Request.post<string>("/login/account", data);
  return new RequestAxios().post("/login/account", data);
}

// 2.获取用户信息
export const getUserInfo = (): Promise<Record<string, ValueType> | ""> => {
  // return Request.get<UserInfoModel>("/users")
  return new RequestAxios().get("/users");
}

// 3.获取本月任务数据
export const getUserTaskInfo = (data: UserTaskInfoParamsModel): Promise<Record<string, ValueType> | ""> => {
  return new RequestAxios().get('/users/taskReport', data);
  // return Request.get<UserTaskInfoModel>('/users/taskReport', data)
}