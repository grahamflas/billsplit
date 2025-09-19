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
  destroyNotification: (notification: Notification) => void;
  notification: Notification;
}

const NotificationsMenuItem = ({
  destroyNotification,
  notification,
}: Props) => {
  switch (notification.category) {
    case "expense_added":
      return (
        <ExpenseAddedNotification
          destroyNotification={destroyNotification}
          expense={notification.source as Expense}
          notification={notification}
        />
      );

    case "expense_updated":
      return (
        <ExpenseUpdatedNotification
          destroyNotification={destroyNotification}
          expense={notification.source as Expense}
          notification={notification}
        />
      );

    case "settlement_created":
      return (
        <SettlementCreatedNotification
          destroyNotification={destroyNotification}
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
