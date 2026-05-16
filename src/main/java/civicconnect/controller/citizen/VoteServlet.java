package civicconnect.controller.citizen;

import civicconnect.dao.ComplaintDAO;
import civicconnect.dao.VoteDAO;
import civicconnect.model.Votes;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/citizen/vote")
public class VoteServlet extends HttpServlet {

    private final VoteDAO voteDAO = new VoteDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String complaintIdStr = request.getParameter("complaintId");
        
        if (complaintIdStr == null || complaintIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);

            // Check if user already voted
            if (voteDAO.hasUserVoted(userId, complaintId)) {
                // Remove vote (Un-support)
                if (voteDAO.removeVote(userId, complaintId)) {
                    complaintDAO.updateVoteCount(complaintId, -1);
                    response.getWriter().write("unvoted");
                }
            } else {
                // Add vote
                Votes vote = new Votes();
                vote.setUserId(userId);
                vote.setComplaintId(complaintId);
                if (voteDAO.addVote(vote)) {
                    complaintDAO.updateVoteCount(complaintId, 1);
                    response.getWriter().write("voted");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
