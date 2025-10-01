import { useState } from "react";

import { format } from "date-fns";

import { formatCurrency } from "../utils/formatCurrency";

import GroupDetailsData from "./GroupDetailsData";
import SettlementDetails from "./SettlementDetails";

import { Settlement, User } from "../types/BaseInterfaces";

interface Props {
  currentUser: User;
  isInitialSettlement: boolean;
  settlement: Settlement;
}

const SettlementContainer = ({
  currentUser,
  isInitialSettlement,
  settlement,
}: Props) => {
  const [showMore, setShowMore] = useState(false);

  return (
    <>
      {!isInitialSettlement && <hr />}

      <div className="flex flex-col gap-6">
        <div className="flex justify-between">
          <GroupDetailsData
            headingClasses="text-2xl"
            headingData={formatCurrency(settlement.balances.totalExpenses)}
            subHeadingClasses="text-neutral-500"
            subHeadingData={`${
              settlement.expenses.length
            } expenses | Settled on ${format(
              new Date(settlement.createdAt),
              "MMM d, yyyy"
            )}`}
          />

          <button
            className="text-indigo-500"
            onClick={() => setShowMore(!showMore)}
          >
            {showMore ? "Hide details" : "Show details"}
          </button>
        </div>

        {showMore && (
          <SettlementDetails
            currentUser={currentUser}
            settlement={settlement}
          />
        )}
      </div>
    </>
  );
};

export default SettlementContainer;
