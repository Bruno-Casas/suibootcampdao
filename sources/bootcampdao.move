/// Sistema de votação descentralizado (DAO)
#[allow(lint(public_entry))]
module bootcampdao::bootcampdao;

use std::string::String;
use sui::event;

// Erros

const EProposalNotActive: u64 = 0;
const EAlreadyVoted: u64 = 1;
const ENotAdmin: u64 = 2;

// Estruturas

public struct Proposal has key {
    id: UID,
    title: String,
    description: String,
    creator: address,
    votes_for: u64,
    votes_against: u64,
    voters: vector<address>,
    is_active: bool,
}

// Eventos

public struct ProposalCreated has copy, drop {
    proposal_id: ID,
    title: String,
    creator: address,
}

public struct VoteCast has copy, drop {
    proposal_id: ID,
    voter: address,
    voted_for: bool,
}

public struct ProposalClosed has copy, drop {
    proposal_id: ID,
    votes_for: u64,
    votes_against: u64,
    passed: bool,
}

// Funções Públicas

public entry fun create_proposal(
    title: String,
    description: String,
    ctx: &mut TxContext
) {
    let proposal_uid = object::new(ctx);
    let proposal_id = object::uid_to_inner(&proposal_uid);
    let sender = tx_context::sender(ctx);

    let proposal = Proposal {
        id: proposal_uid,
        title,
        description,
        creator: sender,
        votes_for: 0,
        votes_against: 0,
        voters: vector::empty(),
        is_active: true,
    };

    event::emit(ProposalCreated {
        proposal_id,
        title: proposal.title,
        creator: sender,
    });

    transfer::share_object(proposal);
}

public entry fun vote(
    proposal: &mut Proposal,
    vote_for: bool,
    ctx: &mut TxContext
) {
    let sender = tx_context::sender(ctx);

    assert!(proposal.is_active, EProposalNotActive);
    
    assert!(!vector::contains(&proposal.voters, &sender), EAlreadyVoted);

    if (vote_for) {
        proposal.votes_for = proposal.votes_for + 1;
    } else {
        proposal.votes_against = proposal.votes_against + 1;
    };

    vector::push_back(&mut proposal.voters, sender);

    event::emit(VoteCast {
        proposal_id: object::id(proposal),
        voter: sender,
        voted_for: vote_for,
    });
}

public entry fun close_proposal(
    proposal: &mut Proposal,
    ctx: &mut TxContext
) {
    let sender = tx_context::sender(ctx);
    
    assert!(proposal.is_active, EProposalNotActive);
    assert!(sender == proposal.creator, ENotAdmin);

    proposal.is_active = false;

    event::emit(ProposalClosed {
        proposal_id: object::id(proposal),
        votes_for: proposal.votes_for,
        votes_against: proposal.votes_against,
        passed: proposal.votes_for > proposal.votes_against,
    });
}

// Funções de visualização

public fun get_votes(proposal: &Proposal): (u64, u64) {
    (proposal.votes_for, proposal.votes_against)
}

public fun is_active(proposal: &Proposal): bool {
    proposal.is_active
}

public fun get_voter_count(proposal: &Proposal): u64 {
    vector::length(&proposal.voters)
}
