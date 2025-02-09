import {
  CarRecordParamsModel,
  DeliverParamsModel,
  PickUpParamsModel,
  TaskDetailInfoModel,
  TaskListData,
  TaskListParams
} from "../models";
import { Request } from "../utils";

/**
 * 获取任务列表接口
 */
export const getTaskList = (params: TaskListParams) => {
  return Request.get<TaskListData>("/tasks/list", params)
}

/**
 * 获取任务详情
 */
export const getTaskDetail = (id: string) => {
  return Request.get<TaskDetailInfoModel>(`/tasks/details/${id}`)
}

/**
 * 提货接口
 */
export const pickUp = (params: PickUpParamsModel) => {
  return Request.post<null>("/tasks/takeDelivery", params)
}

/**
 * 交货接口
 */
export const deliver = (params: DeliverParamsModel) => {
  return Request.post<null>("/tasks/deliver", params)
}

/**
 * 回车登记
 * @param params 回车登记接口数据
 */
export const carRecord = (params: CarRecordParamsModel) => {
  return Request.post<null>("/tasks/truckRegistration", params)
}