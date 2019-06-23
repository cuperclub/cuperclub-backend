module Api
  module Admin
    class CompaniesController < BaseController
      before_action :authenticate_user!,
                    :find_company,
                    except: [:index]

      api :GET,
          "/admin/companies",
          "Get all companies"
      example %q{
        "companies":[{
          "ruc":"5184135690",
          "business_name":"The Krusty krab.",
          "contributor_type":"Natural",
          "economic_activity":"Restaurant",
          "legal_representative":"Mr. Krabs",
          "logo":null,
          "slogan":"a cool slogan",
        }]
      }

      def index
        companies = Company.all
        render :companies,
              status: :created,
              locals: { companies: companies }
      end

      api :GET,
          "/admin/companies/:id",
          "Get a company"
      param :id, Integer, required: true
      example %q{
        "company":{
          "ruc":"5184135690",
          "business_name":"The Krusty krab.",
          "contributor_type":"Natural",
          "economic_activity":"Restaurant",
          "legal_representative":"Mr. Krabs",
          "logo":null,
          "slogan":"a cool slogan",
        }
      }

      def show
        render :company,
                status: :accepted,
                locals: { company: @company }
      end

      api :PUT,
          "/admin/companies/:id/change_status",
          "Change status company"
      param :id, Integer, required: true
      param :status, String, required: true
      example %q{
        "company":{
          "ruc":"5184135690",
          "business_name":"The Krusty krab.",
          "contributor_type":"Natural",
          "economic_activity":"Restaurant",
          "legal_representative":"Mr. Krabs",
          "logo":null,
          "slogan":"a cool slogan",
          "status":"approved"
        }
      }

      def change_status
        employee = @company.employees.find_by_role("partner")
        employee.status = params[:status]
        if employee.save
          render :company,
                  status: :accepted,
                  locals: { company: @company }
        else
          render json: employee.errors,
                status: :unprocessable_entity
        end
      end

      private

      def find_company
        @company = Company.find(params[:id])
      end
    end
  end
end
