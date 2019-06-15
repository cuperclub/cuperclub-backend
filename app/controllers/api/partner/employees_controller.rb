module Api
  module Partner
    class EmployeesController < BaseController
      before_action :authenticate_user!
      before_action :find_company, only: [:index, :show, :update]

      api :GET,
          "/partner/companies/:company_id/employees",
          "Get all employees"
      example %q{
        "employees":[{
          "user": {
            "email": "cashier@example.com",
            "nickname": "chasier",
            "name": "Chasier",
            "national_id": "1234567892",
          },
          "role": "cashier",
          "active": true
        }]
      }

      def index
        employees = @company.employees
                            .where.not(user: current_user)
        render :employees,
              status: :created,
              locals: { employees: employees }
      end

      api :GET,
          "/partner/companies/:company_id/employees/:id",
          "Get a employee"
      param :id, Integer, required: true
      example %q{
        "employee":{
          "user": {
            "email": "cashier@example.com",
            "nickname": "chasier",
            "name": "Chasier",
            "national_id": "1234567892",
          },
          "role": "cashier",
          "active": true
        }
      }

      def show
        employee = @company.employees.find(params[:id])
        render :employee,
                status: :accepted,
                locals: { employee: employee }
      end

      api :PUT,
      "/partner/companies/:company_id/employees/:id/update_state",
      "Edit a employee"
      param :id, Integer, required: true
      example %q{
        "employee":{
          "status": "disabled",
          "feedback": "employee in vacations"
        }
      }

      def update_state
        employee = @company.employees.find(params[:id])
        if employee.update(employee_access_params)
          render :employee,
                  status: :accepted,
                  locals: { employee: employee }
        else
          render json: employee.errors,
                status: :unprocessable_entity
        end
      end

      private

      def employee_access_params
        params.require(:employee).permit(
          :status,
          :feedback
        )
      end

      def find_company
        @company = current_user.companies.find(params[:company_id])
      end
    end
  end
end
