(*
 * Copyright (c) 2011-2014 Anil Madhavapeddy <anil@recoil.org>
 * Copyright (c) 2013-2014 Thomas Gazagnaire <thomas@gazagnaire.org>
 * Copyright (c) 2013-2014 Citrix Systems Inc
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

(** lwt-compatible MirageOS signatures.

    {e Release %%VERSION%% } *)

open V1

module type TIME = Mirage_time_lwt.S
module type RANDOM = Mirage_random.C
module type FLOW = Mirage_flow_lwt.S

(** Consoles *)
module type CONSOLE = Mirage_console_lwt.S

(** Block devices *)
module type BLOCK = Mirage_block_lwt.S

(** Network *)
module type NETWORK = Mirage_net_lwt.S

(** Ethernet interface *)
module type ETHIF = ETHIF
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t
   and type macaddr = Macaddr.t

(** ARP interface *)
module type ARP = ARP
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t
   and type ipaddr = Ipaddr.V4.t
   and type macaddr = Macaddr.t

(** IP stack *)
module type IP = IP
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t
   and type uipaddr = Ipaddr.t

(** IPv4 stack *)
module type IPV4 = IPV4
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t
   and type ipaddr = Ipaddr.V4.t
   and type prefix = Ipaddr.V4.Prefix.t
   and type uipaddr = Ipaddr.t

(** IPv6 stack *)
module type IPV6 = IPV6
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t
   and type ipaddr = Ipaddr.V6.t
   and type prefix = Ipaddr.V6.Prefix.t
   and type uipaddr = Ipaddr.t

(** ICMP module *)
module type ICMP = ICMP
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t

(** ICMPV4 module *)
module type ICMPV4 = ICMPV4
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t
   and type ipaddr = Ipaddr.V4.t

(** UDP stack *)
module type UDP = UDP
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t

(** UDP stack over IPv4 *)
module type UDPV4 = UDP
  with type ipaddr = Ipaddr.V4.t

(** UDP stack over IPv6 *)
module type UDPV6 = UDP
  with type ipaddr = Ipaddr.V6.t

(** TCP stack *)
module type TCP = TCP
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t

(** TCP stack over IPv4 *)
module type TCPV4 = TCP
  with type ipaddr = Ipaddr.V4.t

(** TCP stack over IPv6 *)
module type TCPV6 = TCP
  with type ipaddr = Ipaddr.V6.t

(** Buffered TCP channel *)
module type CHANNEL = CHANNEL
  with type 'a io = 'a Lwt.t
   and type buffer = Cstruct.t

(** KV RO *)
module type KV_RO = Mirage_kv_lwt.RO

(** FS *)
module type FS = Mirage_fs_lwt.S

(** Configuration *)

type socket_stack_config =
  Ipaddr.V4.t list

type ipv4_config = {
  address : Ipaddr.V4.t;
  network : Ipaddr.V4.Prefix.t;
  gateway : Ipaddr.V4.t option;
}

type ipv6_config = {
  address : Ipaddr.V6.t list;
  netmasks : Ipaddr.V6.Prefix.t list;
  gateways : Ipaddr.V6.t list;
}

type 'netif stackv4_config = {
  name: string;
  interface: 'netif;
}

(** {1 DHCP client}
 *  A client which engages in lease transactions. *)
module type DHCP_CLIENT = sig
  type t = ipv4_config Lwt_stream.t
end


(** Single network stack *)
module type STACKV4 = STACKV4
  with type 'a io = 'a Lwt.t
   and type 'a config = 'a stackv4_config
   and type ipv4addr = Ipaddr.V4.t
   and type buffer = Cstruct.t
