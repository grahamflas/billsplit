import { useState } from "react";

import { format, max } from "date-fns";

import { FaArrowLeft } from "react-icons/fa";

import BalancesData from "./BalancesData";
import BillSplitAccordion from "./BillSplitAccordion";
import Expense from "./Expense";
import GroupDetailsData from "./GroupDetailsData";
import GroupDetailsSection from "./GroupDetailsSection";
import GroupedAvatars from "./GroupedAvatars";
import SettleExpensesModal from "./SettleExpensesModal";
import SettledExpensesAccordionContent from "./SettledExpensesAccordionContent";

import { Balances, Group, Settlement, User } from "../types/BaseInterfaces";
import { ExpenseStatus } from "../enums/ExpenseStatus";

interface Props {
  balances: Balances;
  currentUser: User;
  group: Group;
  settlements: Settlement[];
}

const GroupDetails = ({ balances, currentUser, group, settlements }: Props) => {
  const [showSettleExpensesModal, setShowSettleExpensesModal] = useState(false);

  const groupMembersList = () => {
    return group.users.map((user) => user.firstName).join(", ");
  };

  const openExpenses = group.expenses.filter(
    (expense) => expense.status === ExpenseStatus.Open
  );

  const deletedExpenses = group.expenses.filter(
    (expense) => expense.status === ExpenseStatus.Deleted
  );

  const latestDate = () => {
    if (group.expenses.length > 0) {
      const dates = group.expenses.map(
        (expense) => new Date(expense.createdAt)
      );

      return format(max(dates), "MMM d, yyyy");
    }

    return "-";
  };

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <a className="flex items-center gap-1 text-indigo-600 text-xl" href="/">
        <FaArrowLeft /> Back to My Groups
      </a>

      <div className="flex flex-col gap-6 mt-6">
        <GroupDetailsSection>
          <>
            <div className="flex flex-row justify-between">
              <div className="flex flex-col gap-1">
                <h2 className="text-4xl">{group.name}</h2>

                <span className="text-neutral-500">{groupMembersList()}</span>
              </div>

              <div className="flex flex-row -space-x-2">
                <GroupedAvatars users={group.users} />
              </div>
            </div>

            <div id="balances" className="rounded-2xl bg-neutral-100 p-6 mx-4">
              <GroupDetailsData
                headingData="Total Expenses"
                id={"total-expenses"}
                subHeadingData={Intl.NumberFormat("en-US", {
                  style: "currency",
                  currency: "USD",
                }).format(balances.totalExpenses)}
                subHeadingClasses="text-3xl mt-2"
              />

              <div className="mt-8">
                <BalancesData balances={balances} currentUser={currentUser} />
              </div>
            </div>

            {openExpenses.length > 0 && (
              <button
                className="self-start mx-4 rounded-md px-2 py-1 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-l text-white text-center"
                onClick={() => setShowSettleExpensesModal(true)}
              >
                Settle open expenses
              </button>
            )}

            <div className="flex flex-row justify-between">
              <div>
                <GroupDetailsData
                  headingData="Members"
                  id="group-members-count"
                  subHeadingData={group.users.length}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Expenses"
                  id="open-expenses-count"
                  subHeadingData={openExpenses.length || "-"}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Latest Activity"
                  id="latest-activity"
                  subHeadingData={latestDate()}
                />
              </div>
            </div>
          </>
        </GroupDetailsSection>

        <a
          className="rounded-md px-3 py-2 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-2xl text-center"
          href={`/expenses/new?group_id=${group.id}`}
        >
          + Add Expense
        </a>

        {openExpenses.length > 0 && (
          <GroupDetailsSection id="open-expenses">
            <>
              {openExpenses.map((expense, i) => (
                <Expense
                  expense={expense}
                  group={group}
                  isInitialExpense={i === 0}
                  key={expense.id}
                />
              ))}
            </>
          </GroupDetailsSection>
        )}

        {settlements.length > 0 && (
          <GroupDetailsSection id="settlements">
            <BillSplitAccordion
              headingContent={"Settlements"}
              triggerId="settlements-accordion"
            >
              <SettledExpensesAccordionContent
                currentUser={currentUser}
                settlements={settlements}
              />
            </BillSplitAccordion>
          </GroupDetailsSection>
        )}

        {deletedExpenses.length > 0 && (
          <GroupDetailsSection id="deleted-expenses">
            <BillSplitAccordion
              headingContent="Deleted Expenses"
              triggerId="deleted-expenses-accordion"
            >
              <div className="flex flex-col gap-6 mt-6">
                {deletedExpenses.map((expense, i) => (
                  <Expense
                    expense={expense}
                    group={group}
                    isInitialExpense={i === 0}
                    key={expense.id}
                  />
                ))}
              </div>
            </BillSplitAccordion>
          </GroupDetailsSection>
        )}

        <SettleExpensesModal
          balances={balances}
          currentUser={currentUser}
          group={group}
          id="settle-expenses-modal"
          isOpen={showSettleExpensesModal}
          onClose={() => setShowSettleExpensesModal(false)}
          title={`Settle expenses for ${group.name}`}
        />
      </div>
    </div>
  );
};

export default GroupDetails;
