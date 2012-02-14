module GridData
  module Paginators
    module KaminariPaginator
      extend self

      def do_paging(chain, page_val, per_val)
        chain.page(page_val).per(per_val)
      end
      
    end
  end
end
