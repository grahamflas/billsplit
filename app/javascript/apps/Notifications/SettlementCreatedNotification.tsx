import { IoMdCloseCircleOutline } from "react-icons/io";

import { Notification, Settlement } from "../../types/BaseInterfaces";

interface Props {
  notification: Notification;
  settlement: Settlement;
}

const SettlementCreatedNotification = ({ notification, settlement }: Props) => {
  return (
    <div className="flex gap-2 justify-between items-center border-l-2 border-indigo-300 h-10 p-2 mb-2">
      <a href={notification.link}>
        <div className="text-sm font-bold">
          Settlement created for{" "}
          <span className="text-bold">{settlement.group.name}</span>
        </div>

        <div className="text-xs">
          Total expenses:
          {Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
          }).format(settlement.balances.totalExpenses)}
        </div>
      </a>

      <IoMdCloseCircleOutline size={20} />
    </div>
  );
};

export default SettlementCreatedNotification;
