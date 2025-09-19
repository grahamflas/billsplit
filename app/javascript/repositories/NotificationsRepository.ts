import { Notification } from "../types/BaseInterfaces";
import ajax from "../utils/ajax";

class NotificationsRepository {
  static readonly baseUrl = `/api/notifications`;

  static async destroy(
    notification: Notification
  ): Promise<boolean> {
    try {

      await ajax.delete(`${this.baseUrl}/${notification.id}`);

      return true;
    } catch (error) {
      return false;
    }
  }
}

export default NotificationsRepository;
