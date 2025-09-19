import InformationalNotification from "./Notifications/InformationalNotifiction";
import InvitationCreatedNotification from "./Notifications/InvitationCreatedNotification";

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
    case "expense_added": {
      const expense = notification.source as Expense;

      return (
        <InformationalNotification
          destroyNotification={destroyNotification}
          mainText={`Expense added to ${expense.group.name}`}
          notification={notification}
          subText={`${expense.reference}: ${Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
          }).format(expense.amount)}`}
        />
      );
    }

    case "expense_updated": {
      const expense = notification.source as Expense;

      return (
        <InformationalNotification
          destroyNotification={destroyNotification}
          mainText={`Expense updated for ${expense.group.name}`}
          notification={notification}
          subText={`${expense.reference}: ${Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
          }).format(expense.amount)}`}
        />
      );
    }
    case "settlement_created": {
      const settlement = notification.source as Settlement;

      return (
        <InformationalNotification
          destroyNotification={destroyNotification}
          mainText={`Settlement created for ${settlement.group.name}`}
          notification={notification}
          subText={`Total expenses: ${Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
          }).format(settlement.balances.totalExpenses)}`}
        />
      );
    }

    case "invitation_created": {
      return (
        <InvitationCreatedNotification
          notification={notification}
          invitation={notification.source as Invitation}
        />
      );
    }

    case "member_added_to_group": {
      const invitation = notification.source as Invitation;

      return (
        <InformationalNotification
          destroyNotification={destroyNotification}
          mainText={`${invitation.invitee?.firstName} joined ${invitation.group.name}`}
          notification={notification}
        />
      );
    }

    default:
      null;
  }
};

export default NotificationsMenuItem;
