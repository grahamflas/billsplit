import { Notification } from "../types/BaseInterfaces";
import ajax from "../utils/ajax";

interface NotificationsUpdate {
  count: number;
  notifications: Notification[];
}

class NotificationsRepository {
  static readonly baseUrl = `/api/notifications`;

  static async getNotifications(): Promise<NotificationsUpdate | void> {
    try {
      const response = await ajax.getGeneric<NotificationsUpdate>(this.baseUrl);

      return response.data;
    } catch (error) {
      return undefined;
    }
  }

  static async destroy(notification: Notification): Promise<boolean> {
    try {
      await ajax.delete(`${this.baseUrl}/${notification.id}`);

      return true;
    } catch (error) {
      return false;
    }
  }
}

export default NotificationsRepository;
