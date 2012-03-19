module GridData
  module Paginators
    module Kaminari
      extend self

      def page(chain, page, rows)
        chain.page(page).per(rows)
      end

    end
  end
end
