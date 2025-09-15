import { format } from "date-fns";

import BalancesData from "./BalancesData";
import GroupDetailsData from "./GroupDetailsData";

import { Settlement, User } from "../types/BaseInterfaces";

interface Props {
  currentUser: User;
  settlement: Settlement;
}

const SettlementDetails = ({ currentUser, settlement }: Props) => {
  return (
    <div className="flex flex-col gap-4">
      <div className="rounded-2xl bg-neutral-100 p-6 mx-4">
        <GroupDetailsData
          headingData="Total Expenses"
          id={"total-expenses"}
          subHeadingData={Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
          }).format(settlement.balances.totalExpenses)}
          subHeadingClasses="text-3xl mt-2"
        />

        <div className="mt-8">
          <BalancesData
            balances={settlement.balances}
            currentUser={currentUser}
          />
        </div>
      </div>

      <table className="table-auto border-spacing-2">
        <thead>
          <tr>
            <th className="text-left px-2" scope="col">
              Reference
            </th>

            <th className="text-left px-2" scope="col">
              Amount
            </th>

            <th className="text-left px-2" scope="col">
              Date
            </th>

            <th className="text-left px-2" scope="col">
              Paid by
            </th>
          </tr>
        </thead>

        <tbody>
          {settlement.expenses.map((expense) => {
            return (
              <tr
                className="border border-cream border-x-0 border-t-0"
                key={expense.id}
              >
                <td className="px-2">{expense.reference}</td>

                <td className="px-2">{expense.amount}</td>

                <td className="px-2">
                  {format(new Date(expense.createdAt), "MMM d, yyyy")}
                </td>
                <td className="px-2">{`${expense.user.firstName} ${expense.user.lastName}`}</td>
              </tr>
            );
          })}
        </tbody>
      </table>

      {settlement.note && (
        <p>
          <span className="font-semibold">Note:</span> {settlement.note}
        </p>
      )}
    </div>
  );
};

export default SettlementDetails;
