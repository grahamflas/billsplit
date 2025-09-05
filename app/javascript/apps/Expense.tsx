import { format } from "date-fns";
import { Expense } from "../types/BaseInterfaces";
import GroupDetailsData from "./GroupDetailsData";

interface Props {
  expense: Expense;
  isInitialExpense: boolean;
}

const Expense = ({ expense, isInitialExpense }: Props) => {
  return (
    <>
      {!isInitialExpense && <hr />}

      <div className="flex justify-between items-center">
        <GroupDetailsData
          headingData={expense.reference}
          headingClasses="text-2xl"
          subHeadingData={`Paid by ${expense.user.firstName} ${
            expense.user.lastName
          } on ${format(new Date(expense.createdAt), "MMM d, yyyy")}`}
          subHeadingClasses="text-neutral-500"
        />

        <div className="text-2xl">${expense.amount}</div>
      </div>
    </>
  );
};

export default Expense;
