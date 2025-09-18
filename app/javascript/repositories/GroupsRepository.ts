import { toast } from "react-toastify";
import { Group } from "../types/BaseInterfaces";
import ajax from "../utils/ajax";
import { AxiosError } from "axios";

interface GroupResponse {
  group: Group;
  errors: string[];
}

class GroupsRepository {
  static readonly baseUrl = "/api/groups";

  static async create({
    name,
    userIds,
  }: {
    name: string | undefined;
    userIds: number[] | undefined;
  }): Promise<GroupResponse | void> {
    try {
      const data = {
        group: {
          name,
          user_ids: userIds,
        },
      };

      const response = await ajax.postGeneric<GroupResponse>(
        this.baseUrl,
        data
      );

      return response.data;
    } catch (exception) {
      const error = exception as AxiosError<GroupResponse>;

      if (error.response && error.response.data.errors) {
        error.response.data.errors.forEach((error) => toast(error));

        return;
      }

      toast("Something went wrong");
    }
  }

  static async update({
    name,
    groupId,
    userIds,
  }: {
    name: string | undefined;
    groupId: number | undefined;
    userIds: number[] | undefined;
  }): Promise<GroupResponse | void> {
    try {
      const data = {
        group: {
          name,
          user_ids: userIds,
        },
      };

      const response = await ajax.putGeneric<GroupResponse>(
        `${this.baseUrl}/${groupId}`,
        data
      );

      return response.data;
    } catch (exception) {
      const error = exception as AxiosError<GroupResponse>;

      if (error.response && error.response.data.errors) {
        error.response.data.errors.forEach((error) => toast(error));

        return;
      }

      toast("Something went wrong");
    }
  }
}

export default GroupsRepository;
