import SettlementContainer from "./SettlementContainer";

import { Settlement, User } from "../types/BaseInterfaces";

interface Props {
  currentUser: User;
  settlements: Settlement[];
}

const SettledExpensesAccordionContent = ({
  currentUser,
  settlements,
}: Props) => {
  return (
    <div className="flex flex-col gap-6 mt-6">
      {settlements.map((settlement, index) => (
        <SettlementContainer
          currentUser={currentUser}
          isInitialSettlement={index === 0}
          key={settlement.id}
          settlement={settlement}
        />
      ))}
    </div>
  );
};

export default SettledExpensesAccordionContent;
