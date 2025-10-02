import { format } from "date-fns";

import { formatCurrency } from "../utils/formatCurrency";

import InformationalNotification from "./Notifications/InformationalNotifiction";
import InvitationCreatedNotification from "./Notifications/InvitationCreatedNotification";

import {
  Expense,
  Group,
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
          subText={`${expense.reference}: ${formatCurrency(expense.amount)}`}
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
          subText={`${expense.reference}: ${formatCurrency(expense.amount)}`}
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
          subText={`Total expenses: ${formatCurrency(
            settlement.balances.totalExpenses
          )}`}
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

    case "invitation_declined": {
      const invitation = notification.source as Invitation;

      return (
        <InformationalNotification
          destroyNotification={destroyNotification}
          mainText={`${invitation.invitee?.firstName} declined to join ${invitation.group.name}`}
          notification={notification}
        />
      );
    }

    case "group_archived": {
      const group = notification.source as Group;

      return (
        <InformationalNotification
          destroyNotification={destroyNotification}
          mainText={`${group.name} was archived on ${format(
            group.archivedOn,
            "d MMM yyyy"
          )}`}
          notification={notification}
        />
      );
    }

    default:
      null;
  }
};

export default NotificationsMenuItem;
