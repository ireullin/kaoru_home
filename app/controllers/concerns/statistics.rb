require "rinruby"


class Statistics

	def self.rank_count( arr )

        r = RinRuby.new( interactive: true, echo: false )
        r.assign "all_no", arr
        r.eval """
            x <- c( all_no )
            dt <- data.frame(sort(table(x),decreasing = TRUE))
            cnt = c(dt[,1])
            num = c(row.names(dt))
        """
        rc = {
            numbers: r.pull("num"),
            count: r.pull("cnt")
        }
        r.quit

        return rc
    end
end

