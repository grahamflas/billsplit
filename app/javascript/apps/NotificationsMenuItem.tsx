import ExpenseAddedNotification from "./Notifications/ExpenseAddedNotification";
import ExpenseUpdatedNotification from "./Notifications/ExpenseUpdatedNotification";
import InvitationCreatedNotification from "./Notifications/InvitationCreatedNotification";
import SettlementCreatedNotification from "./Notifications/SettlementCreatedNotification";

import {
  Expense,
  Invitation,
  Notification,
  Settlement,
} from "../types/BaseInterfaces";

interface Props {
  notification: Notification;
}

const NotificationsMenuItem = ({ notification }: Props) => {
  switch (notification.category) {
    case "expense_added":
      return (
        <ExpenseAddedNotification
          notification={notification}
          expense={notification.source as Expense}
        />
      );

    case "expense_updated":
      return (
        <ExpenseUpdatedNotification
          notification={notification}
          expense={notification.source as Expense}
        />
      );

    case "settlement_created":
      return (
        <SettlementCreatedNotification
          notification={notification}
          settlement={notification.source as Settlement}
        />
      );

    case "invitation_created":
      return (
        <InvitationCreatedNotification
          notification={notification}
          invitation={notification.source as Invitation}
        />
      );

    default:
      null;
  }
};

export default NotificationsMenuItem;
